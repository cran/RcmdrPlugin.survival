# last modified 2022-10-27

CoxZPH <- function(){
  initializeDialog(title=gettext("Test Proportional Hazards", domain="R-RcmdrPlugin.survival"))
  onOK <- function(){
    termsTest <- as.character(tclvalue(termsTestVariable))
    testTerms <- termsTest == "terms"
    termsPlot <- as.character(tclvalue(termsPlotVariable))
    plotTerms <- termsPlot == "terms"
    closeDialog()
    command <- paste0("testPropHazards(",  ActiveModel(), ', test.terms=', testTerms,
                      ', plot.terms=', plotTerms, ')')
    doItAndPrint(command)
    tkfocus(CommanderWindow())
  }
  OKCancelHelp(helpSubject="cox.zph")
  termsFrame <- tkframe(top)
  radioButtons(termsFrame, name="termsTest",
               buttons=c("coefficients", "terms"),
               labels=gettext(c("Coefficients", "Terms"), domain="R-RcmdrPlugin.survival"),
               initialValue="coefficients", title=gettext("Test by", domain="R-RcmdrPlugin.survival"))
  radioButtons(termsFrame, name="termsPlot",
               buttons=c("coefficients", "terms"),
               labels=gettext(c("Coefficients", "Terms"), domain="R-RcmdrPlugin.survival"),
               initialValue="coefficients", title=gettext("Plot by", domain="R-RcmdrPlugin.survival"))
  tkgrid(termsTestFrame, sticky="w")
  tkgrid(labelRcmdr(termsFrame, text=""))
  tkgrid(termsPlotFrame, sticky="w")
  tkgrid(termsFrame, sticky="w")
  tkgrid(labelRcmdr(top, text=""))
  tkgrid(buttonsFrame, sticky="w")
  dialogSuffix()
}
