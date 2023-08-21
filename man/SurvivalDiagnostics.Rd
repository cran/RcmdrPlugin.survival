\name{SurvivalDiagnostics}
\alias{SurvivalDiagnostics}
\alias{crPlots}
\alias{crPlots.coxph}
\alias{dfbeta.coxph}
\alias{plot.dfbeta.coxph}
\alias{dfbetas.coxph}
\alias{plot.dfbetas.coxph}
\alias{dfbeta.survreg}
\alias{plot.dfbeta.survreg}
\alias{dfbetas.survreg}
\alias{plot.dfbetas.survreg}
\alias{MartingalePlots}
\alias{MartingalePlots.coxph}
\alias{testPropHazards}
\alias{testPropHazards.coxph}

\title{
Diagnostics for Survival Regression Models
}

\description{
These are primarily convenience functions for the \pkg{RcmdrPlugin.survival} package, to produce diagnostics for \code{\link[survival]{coxph}} and \code{\link[survival]{survreg}} models in a convenient form for plotting via the package's GUI.
}

\usage{
crPlots(model, ...)
\method{crPlots}{coxph}(model, ...)

\method{dfbeta}{coxph}(model, ...)
\method{plot}{dfbeta.coxph}(x, ...)

\method{dfbetas}{coxph}(model, ...)
\method{plot}{dfbetas.coxph}(x, ...)

\method{dfbeta}{survreg}(model, ...)
\method{plot}{dfbeta.survreg}(x, ...)

\method{dfbetas}{survreg}(model, ...)
\method{plot}{dfbetas.survreg}(x, ...)

MartingalePlots(model, ...)
\method{MartingalePlots}{coxph}(model, ...)

testPropHazards(model, test.terms = FALSE, plot.terms = FALSE, ...)
\method{testPropHazards}{coxph}(model, test.terms = FALSE, plot.terms = FALSE, ...)
}

\arguments{
  \item{model, x}{a Cox regression or parametric survival regression model, as appropriate.}
  \item{test.terms}{test proportional hazards by terms in the Cox model, rather than by coefficients (default is \code{FALSE}).}
  \item{plot.terms}{diagnostic plots of proportional hazards by terms in the Cox model, rather than by coefficients (default is \code{FALSE}).}
  \item{\dots}{arguments to be passed down.}
}

\details{

\itemize{

  \item \code{crPlots.coxph} is a method for the \code{\link[car]{crPlots}} function in the \pkg{car} package, to create component+residual (partial-residual) plots, using \code{\link[survival]{residuals.coxph}} and \code{\link[survival]{predict.coxph}} in the \pkg{survival} package.

  \item \code{testPropHazards} is essentially a wrapper for the \code{\link[survival]{cox.zph}} function in the \pkg{survival} package.
  
  \item \code{MartingalePlots} creates null-model Martingale plots for Cox regression models, using the \code{\link[survival]{residuals.coxph}} function in the \pkg{survival} package.
  
  \item \code{dfbeta.coxph} and \code{dfbetas.coxph} provide methods for the standard \code{\link{dfbeta}} and \code{\link{dfbetas}} functions, using the \code{\link[survival]{residuals.coxph}} function in the \pkg{survival} package for computation. \code{plot.dfbeta.coxph} and \code{plot.dfbetas.coxph} are plot methods for the objects produced by these functions.
  
  \item \code{dfbeta.survreg}, \code{dfbetas.survreg}, \code{plot.dfbeta.survreg} and \code{plot.dfbetas.survreg} are similar methods for \code{\link[survival]{survreg}} objects.
}
}


\value{
Most of these function create graphs and don't return useful values; the \code{dfbeta} and \code{dfbetas} methods create matrices of dfbeta and dfbetas values.
}

\author{John Fox <jfox@mcmaster.ca>}

\references{
	John Fox, Marilia Sa Carvalho (2012).
    The RcmdrPlugin.survival Package: Extending the R Commander Interface to Survival Analysis.
    \emph{Journal of Statistical Software}, 49(7), 1-32. \doi{10.18637/jss.v049.i07}.
} 

\seealso{
\code{\link[survival]{coxph}}, \code{\link[survival]{survreg}}, \code{\link[car]{crPlots}}, \code{\link[survival]{residuals.coxph}}, \code{\link[survival]{residuals.survreg}}, \code{\link[survival]{predict.coxph}}, \code{\link[survival]{cox.zph}}
}
