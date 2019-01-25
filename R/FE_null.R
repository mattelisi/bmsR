#' Calculate free energy for H0 (equal model frequencies in the population)
#'
#' THis function derives the free energy of the 'null' (H0: equal model frequencies). This routine has been copied from the VBA_groupBMC function of the VBA toolbox http://code.google.com/p/mbb-vb-toolbox/ which was written by Lionel Rigoux and J. Daunizeau. See Equation A.17 in Rigoux et al.
#' @param m N by K (N subjects by K models) matrix of log-model evidence.
#' @return Free energy.
#' @export

FE_null <- function(m){
  n <- dim(m)[1]  # number of subjects
  K <- dim(m)[2]  # number of models
  F0m <- 0
  for(i in 1:n){
    tmp <- m[i,] - max(m[i,])
    g <- exp(tmp)/sum(exp(tmp))
    for(k in 1:K){
      F0m = F0m + g[k] * (m[i,k]-log(K)-log(g[k]+.Machine$double.eps))
    }
  }
  return(unname(F0m))
}
