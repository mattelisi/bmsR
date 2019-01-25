#' Calculate free energy for the approximate posterior
#'
#' This function derives the free energy for the current approximate posterior. This routine has been translated from the VBA_groupBMC function of the VBA toolbox http://code.google.com/p/mbb-vb-toolbox/ which was written by Lionel Rigoux and J. Daunizeau. See equation A.20 in Rigoux et al. (should be F1 on LHS)
#' @param m N by K (N subjects by K models) matrix of log-model evidence.
#' @param alpha Dirichlet parameters (usually the posterior estimate).
#' @param g N by K (N subjects by K models) matrix of normalized posterior beliefs.
#' @return Free energy (evidence in favor of different model frequencies).
#' @export

FE <- function(m, a, g){
  a0 <- rep(1, Nk)
  n <- dim(m)[1]  # number of subjects
  K <- dim(m)[2]  # number of models
  Elogr <- digamma(a)- digamma(sum(a))
  Sqf <- sum(lgamma(a)) - lgamma(sum(a)) - sum((a-1)*Elogr)
  Sqm <- 0
  for(i in 1:n){
    Sqm <- Sqm - sum(g[i,] * log(g[i,]+.Machine$double.eps))
  }
  ELJ <- lgamma(sum(a0)) - sum(lgamma(a0)) + sum((a0-1)*Elogr)
  for(i in 1:n){
    for(k in 1:K){
      ELJ <- ELJ + g[i,k]*(Elogr[k]+m[i,k])
    }
  }
  F_ <- ELJ + Sqf + Sqm
  return(F_)
}
