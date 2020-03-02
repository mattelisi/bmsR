#' Compute exceedance probabilities
#'
#' This function compute exceedance probabilities by simulating the multivariate Dirichlet observations using the same approach implemented in SPM 12.
#' @param alpha Dirichlet parameters (usually the posterior estimate).
#' @param Nsamp number of samples drawn.
#' @return Exceedance probabilities.
#' @export

dirichlet_exceedance <- function(alpha, Nsamp=1e6){
  Nk <- length(alpha)
  ind_max <- function(x) ifelse(x==max(x),1,0)
  xp <- rep(0,Nk)
  
  # Sample from univariate gamma densities then normalise
  # (see Dirichlet entry in Wikipedia or Ferguson (1973) Ann. Stat. 1,
  #   % 209-230)
  r = mlisi::repmat(as.matrix(0), Nsamp, Nk)
    
  for(k in 1:Nk){
    r[,k] <- rgamma(Nsamp, alpha[k], scale = 1)
  }
  sr <- apply(r,1,sum)
    
  for(k in 1:Nk){
    r[,k] <- r[,k]/sr
  }
    
  # Exceedance probabilities:
  # For any given model k1, compute the probability that it is more
  # likely than any other model k2~=k1
  j <- apply(r, 1, which.max)
  # xp <- xp + unname(tapply(j, factor(j),length)) # old
  label_j <- factor(j, levels=1:Nk)
  xp <- xp + unname(tapply(j, label_j,length))
  
  # if there's any model which was never the most frequent
  # then it's value would turn out to be NA here
  # so I cahnge it to zero
  xp <- ifelse(is.na(xp),0,xp)
  xp <-xp/Nsamp
}
