% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/FE.R
\name{FE}
\alias{FE}
\title{Calculate free energy for the approximate posterior}
\usage{
FE(m, a, g)
}
\arguments{
\item{m}{N by K (N subjects by K models) matrix of log-model evidence.}

\item{g}{N by K (N subjects by K models) matrix of normalized posterior beliefs.}

\item{alpha}{Dirichlet parameters (usually the posterior estimate).}
}
\value{
Free energy (evidence in favor of different model frequencies).
}
\description{
This function derives the free energy for the current approximate posterior. This routine has been translated from the VBA_groupBMC function of the VBA toolbox http://code.google.com/p/mbb-vb-toolbox/ which was written by Lionel Rigoux and J. Daunizeau. See equation A.20 in Rigoux et al. (should be F1 on LHS)
}
