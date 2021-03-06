#' Bayesian model selection for group studies
#'
#' This function is translated from spm_BMS.m function, of SPM12, https://github.com/neurodebian/spm12/blob/master/spm_BMS.m
#' @param m N by K (N subjects by K models) matrix of log-model evidence.
#' @param n_samples Number of samples used in the simulation used for calculating exceedance probabilities.
#' @return a list with the posterior estimates of the Dirichlet parameters (alpha), the expected model frequencies (r), the exceedance probabilities (xp), the Bayesian Omnibus Risk (bor), and the protected exceedance probabilities (pxp).
#' @export

VB_bms <-function(m, n_samples=1e6){
  
  max_val <- log(.Machine$double.xmax)
  Ni      <- dim(m)[1]  # number of subjects
  Nk      <- dim(m)[2]  # number of models
  c       <- 1
  cc      <- 10e-4
  # norm_vec <- function(x) sqrt(sum(x^2))
  
  alpha0 <- rep(1, Nk)
  
  log_u <- matrix(NA,dim(m)[1],dim(m)[2])
  u <- matrix(NA,dim(m)[1],dim(m)[2])
  g <- matrix(NA,dim(m)[1],dim(m)[2])
  alpha <- alpha0
  beta <- rep(NA,Nk)
    
  # iterative VB estimation
  while(c > cc){
    for(i in 1:Ni){
      for(k in 1:Nk){
        # integrate out prior probabilities of models (in log space)
        log_u[i,k] <- m[i,k] + digamma(alpha[k])- digamma(sum(alpha))
      }
      # prevent numerical problems for badly scaled posteriors
      for(k in 1:Nk){
        log_u[i,k] <- sign(log_u[i,k]) * min(max_val, abs(log_u[i,k]))
      }
      
      # exponentiate (to get back to non-log representation)
      u[i,]  <- exp(log_u[i,])
      
      # normalisation: sum across all models for i-th subject
      u_i  <- sum(u[i,])
      g[i,] <- u[i,]/u_i
    }
    
    # expected number of subjects whose data we believe to have been 
    # generated by model k
    for(k in 1:Nk){
      beta[k] <- sum(g[,k]) 
    }
    
    # update alpha
    prev  <- alpha
    for(k in 1:Nk){
      alpha[k] <- alpha0[k] + beta[k]
    }
    
    # convergence?
    c <- sqrt(sum((alpha - prev)^2))
    
  }
  
  # the posterior p(r|y)
  exp_r <- alpha/sum(alpha)
  
  # exceedance probabilities
  xp <- dirichlet_exceedance(alpha,n_samples)
  
  # Bayes Omnibus Risk and Preotected xp
  F1 <- FE(m, alpha , g) # Evidence of alternative
  F0 <- FE_null(m) # Evidence of null (equal model freqs)
  
  # Implied by Eq 5 (see also p39) in Rigoux et al.
  # See also, last equation in Appendix 2
  bor <- 1/(1+exp(F1-F0))
  
  # Compute protected exceedance probs - Eq 7 in Rigoux et al.
  pxp <- (1-bor)*xp+bor/Nk
  
  # output
  return(list(alpha=alpha, r=exp_r, xp=xp, bor=bor, pxp=pxp))
  
}
