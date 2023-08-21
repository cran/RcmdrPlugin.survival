# last modified 2022-10-27 by J. Fox

# CoxZPH <- function(){
#   doItAndPrint(paste0("testPropHazards(", ActiveModel(), ")"))
# }

CoxDfbeta <- function(){ # works for survreg models as well
  doItAndPrint(paste0("plot(dfbeta(", ActiveModel(), "))"))
  insertRmdSection(paste0("dfbeta Plots: ", ActiveModel()))
}

CoxDfbetas <- function(){ # works for survreg models as well
  doItAndPrint(paste0("plot(dfbetas(", ActiveModel(), "))"))
  insertRmdSection(paste0("dfbetas Plots: ", ActiveModel()))
}

MartingalePlotsDialog <- function(){
  doItAndPrint(paste0("MartingalePlots(", ActiveModel(), ")"))
}

PartialResPlots <- function(){
  doItAndPrint(paste0("crPlots(", ActiveModel(), ")"))
}

testPropHazards <- function (model, test.terms = FALSE, plot.terms = FALSE, ...) UseMethod("testPropHazards")

testPropHazards.coxph <- function(model, test.terms = FALSE, plot.terms = FALSE, ...) {
    plot(zph <- cox.zph(model, terms = plot.terms))
    if (test.terms == plot.terms) {
      print(zph)
    } else {
      print(cox.zph(model, terms = test.terms))
    }
    # nterms <- ncol(attr(terms(model), "factors"))
    # b <- coef(model)
    # zph <- if (nterms < length(b)){
    #   cox.zph(model, terms=FALSE)
    # } else {
    #   cox.zph(model)
    # }
    # nvar <- ncol(zph$y)
    # save.mfrow <- par(mfrow = mfrow(nvar))
    # on.exit(par(save.mfrow))
    # for (i in 1:nvar){
    #   plot(zph[i])
    #   abline(h=b[i], lty=3)
    #   abline(lm(zph$y[, i] ~ zph$x), lty=4)
    # }
    # zph
  }

dfbeta.coxph <- function(model, ...){
  dfbeta <- as.matrix(residuals(model, type="dfbeta"))
  colnames(dfbeta) <- names(coef(model))
  rownames(dfbeta) <- names(residuals(model))
  class(dfbeta) <- c("dfbeta.coxph", class(dfbeta))
  dfbeta
}

plot.dfbeta.coxph <- function(x, ...){
  save.mfrow <- par(mfrow = mfrow(ncol(x)))
  on.exit(par(save.mfrow))
  for (col in colnames(x)){
    plot(x[, col], ylab=col)
    abline(h=0, lty=2)
  }
}

dfbetas.coxph <- function(model, ...){
  dfbetas <- as.matrix(residuals(model, type="dfbetas"))
  colnames(dfbetas) <- names(coef(model))
  rownames(dfbetas) <- names(residuals(model))
  class(dfbetas) <- c("dfbetas.coxph", class(dfbetas))
  dfbetas
}

plot.dfbetas.coxph <- function(x, ...){
  save.mfrow <- par(mfrow = mfrow(ncol(x)))
  on.exit(par(save.mfrow))
  for (col in colnames(x)){
    plot(x[, col], ylab=col)
    abline(h=0, lty=2)
  }
}

dfbeta.survreg <- function(model, ...){
  nc <- length(coef(model))
  dfbeta <- as.matrix(residuals(model, type="dfbeta"))[, 1:nc]
  colnames(dfbeta) <- names(coef(model))
  rownames(dfbeta) <- names(residuals(model))
  class(dfbeta) <- c("dfbeta.survreg", class(dfbeta))
  dfbeta
}

plot.dfbeta.survreg <- function(x, ...){
  save.mfrow <- par(mfrow = mfrow(ncol(x)))
  on.exit(par(save.mfrow))
  for (col in colnames(x)){
    plot(x[, col], ylab=col)
    abline(h=0, lty=2)
  }
}

dfbetas.survreg <- function(model, ...){
  nc <- length(coef(model))
  dfbetas <- as.matrix(residuals(model, type="dfbetas"))[, 1:nc]
  colnames(dfbetas) <- names(coef(model))
  rownames(dfbetas) <- names(residuals(model))
  class(dfbetas) <- c("dfbetas.survreg", class(dfbetas))
  dfbetas
}

plot.dfbetas.survreg <- function(x, ...){
  save.mfrow <- par(mfrow = mfrow(ncol(x)))
  on.exit(par(save.mfrow))
  for (col in colnames(x)){
    plot(x[, col], ylab=col)
    abline(h=0, lty=2)
  }
}

crPlots.coxph <- function(model, ...){
  residuals <- residuals(model, type="partial")
  fitted <- predict(model, type="terms")
  terms <- colnames(residuals)
  nterms <- length(terms)
  save.mfrow <- par(mfrow = mfrow(nterms))
  on.exit(par(save.mfrow))
  for (term in terms){
    x <- fitted[, term]
    if (length(unique(x)) < 10)
      plot(x, residuals[, term], xlab=term, ylab="Partial residuals")
    else scatter.smooth(x, residuals[, term], xlab=term, 
                        ylab="Partial residuals", family="gaussian")
    abline(lm(residuals[, term] ~ x))
  }
}

MartingalePlots <- function(model, ...) UseMethod("MartingalePlots")

MartingalePlots.coxph <- function(model, ...){
  NullModel <- update(model, . ~ 1)
  residuals <- residuals(NullModel, type="martingale")
  X <- padNA(model.matrix(model), residuals(model))
  coefs <- names(coef(model))
  ncoef <- length(coefs)
  save.mfrow <- par(mfrow = mfrow(ncoef))
  on.exit(par(save.mfrow))
  for (coef in coefs){
    x <- X[, coef]
   if (length(unique(x)) < 10)
      plot(x, residuals, xlab=coef, ylab="Martingale residuals (null model)")
    else scatter.smooth(x, residuals, xlab=coef, 
                        ylab="Martingale residuals (null model)", family="gaussian")
    abline(lm(residuals ~ x), lty=2)
  }                   
}