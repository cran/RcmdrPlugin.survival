# last modified 29 January 2009 by J. Fox

Survfit <-
	function(){
	require(survival)
	if (!activeDataSetP()) return()
	currentModel <- FALSE
	initializeDialog(title=gettext("Survival Function", domain="R-RcmdrPlugin.survival"))
	onOK <- function(){
		time <- getSelection(timeBox)
		if (length(time) == 1){
			time1 <- time
			time2 <- numeric(0)
		}
		else if (length(time) == 2){
			ss <- startStop(time)
			if (ss$error) errorCondition(recall=Survfit, 
					message=gettext("Start and stop times must be ordered.", 
						domain="R-RcmdrPlugin.survival"), model=TRUE)
			time1 <- ss$start
			time2 <- ss$stop
		}
		else {
			errorCondition(recall=Survfit, 
				message=gettext("You must select one or two time variables.", 
					domain="R-RcmdrPlugin.survival"))
			return()
		}
		event <- getSelection(eventBox)
		if (length(event) == 0){
			errorCondition(recall=Survfit, message=gettext("You must select an event indicator.", 
					domain="R-RcmdrPlugin.survival"))
			return()
		}
		strata <- getSelection(strataBox)
		type <- as.character(tclvalue(typeVariable))
		error <- as.character(tclvalue(errorVariable))
		conftype <- as.character(tclvalue(conftypeVariable))
		conf.int <- as.character(tclvalue(plotconfVariable))
		lev <- as.numeric(tclvalue(confidenceLevel))
		markTime <- if (tclvalue(markTimeValue)  == 1) "TRUE" else "FALSE"
		quants <- paste("c(", gsub(",+", ",", gsub(" ", ",", tclvalue(quantiles))), ")", sep="")
		closeDialog()
		if ((is.na(lev)) || (lev < 0) || (lev > 1)) {
			errorCondition(recall=Survfit, message=gettext("Confidence level must be a number between 0 and 1.", 
					domain="R-RcmdrPlugin.survival"))
			return()
		}
		subset <- tclvalue(subsetVariable)
		if (trim.blanks(subset) == gettext("<all valid cases>", domain="R-RcmdrPlugin.survival") 
			|| trim.blanks(subset) == ""){
			subset <- ""
		}
		else{
			subset <- paste(", subset=", subset, sep="")
		}
		formula <- paste("Surv(", time1, ",",
			if(length(time2) != 0) paste(time2, ",", sep=""),
			event, ")", sep="")
		if (length(strata) > 0) formula <- paste(formula, " ~ ", paste(strata, collapse=" + "), sep="")
		command <- paste("survfit(", formula, ', conf.type="', conftype, 
			'", conf.int=', lev, ', type="', type, '", error="', error,
			'", data=', ActiveDataSet(), subset, ")", sep="")
		logger(paste(".Survfit <- ", command, sep=""))
		assign(".Survfit", justDoIt(command), envir=.GlobalEnv)
		doItAndPrint("summary(.Survfit)")
		conf.int <- if (conf.int == "default") "" else paste(", conf.int=", conf.int, sep="") 
		if (length(strata) == 0) doItAndPrint(paste("plot(.Survfit", conf.int, ", mark.time=", 
					markTime,  ")", sep=""))
		else{
			allstrata <- eval(parse(text=paste("with(", ActiveDataSet(), 
						", interaction(", paste(strata, collapse=","), "))")))
			levels <- levels(allstrata)
			nlevels <- length(levels)
			doItAndPrint(paste("plot(.Survfit, col=1:", nlevels,", lty=1:", nlevels, 
					', legend.text=c(', paste(paste('"', levels, '"', sep=""), collapse=","),
					')', conf.int, ", mark.time=", markTime, ')', sep=""))
		}
		doItAndPrint(paste("quantile(.Survfit, quantiles=", quants, ")", sep=""))
		logger("remove(.Survfit)")
		remove(.Survfit, envir=.GlobalEnv)
		tkfocus(CommanderWindow())
	}
	OKCancelHelp(helpSubject="survfit")
	survFrame <- tkframe(top)
	.activeDataSet <- ActiveDataSet()
	.numeric <- NumericOrDate()
	.factors <- Factors()
	time1 <- eval(parse(text=paste('attr(', .activeDataSet, ', "time1")', sep="")))
	time1 <- if (!is.null(time1)) which(time1 == .numeric) - 1 
	time2 <- eval(parse(text=paste('attr(', .activeDataSet, ', "time2")', sep="")))
	time2 <- if (!is.null(time2)) which(time2 == .numeric) - 1 
	event <- eval(parse(text=paste('attr(', .activeDataSet, ', "event")', sep="")))
	event <- if (!is.null(event)) which(event == Numeric()) - 1 
	strata <- eval(parse(text=paste('attr(', .activeDataSet, ', "strata")', sep="")))
	strata <- if (!is.null(strata)) which(is.element(.factors, strata)) - 1 else -1
	timeBox <- variableListBox(survFrame, NumericOrDate(), 
		title=gettext("Time or start/end times\n(select one or two)", domain="R-RcmdrPlugin.survival"),
		selectmode="multiple", initialSelection=if(is.null(time1)) NULL else c(time1, time2))
	eventBox <- variableListBox(survFrame, Numeric(), 
		title=gettext("Event indicator\n(select one)", domain="R-RcmdrPlugin.survival"),
		initialSelection=event)
	strataBox <- variableListBox(survFrame, Factors(), 
		title=gettext("Strata\n(select zero or more)", domain="R-RcmdrPlugin.survival"), 
		selectmode="multiple", initialSelection=strata)
	confidenceFrame <- tkframe(top)
	radioButtons(confidenceFrame, name="conftype",
		buttons=c("log", "loglog", "plain", "none"), 
		values=c("log", "log-log", "plain", "none"), initialValue="log",
		labels=gettext(c("Log", "Log-log","Plain", "None")), 
		title=gettext("Confidence Intervals", domain="R-RcmdrPlugin.survival"))
	confidenceLevel <- tclVar(".95")
	confidenceFieldFrame <- tkframe(confidenceFrame)
	confidenceField <- ttkentry(confidenceFieldFrame, width="6", textvariable=confidenceLevel)
	radioButtons(confidenceFrame, name="plotconf",
		buttons=c("default", "yes", "no"), 
		values=c("default", "TRUE", "FALSE"), initialValue="default",
		labels=gettext(c("Default", "Yes", "No"), domain="R-RcmdrPlugin.survival"), 
		title=gettext("Plot confidence Intervals", domain="R-RcmdrPlugin.survival"))
	optionsFrame <- tkframe(top)
	radioButtons(optionsFrame, name="type",
		buttons=c("kaplanmeier","flemingharrington", "fh2"), 
		values=c("kaplan-meier","fleming-harrington", "fh2"), initialValue="kaplan-meier",
		labels=gettext(c("Kaplan-Meier", "Fleming-Harrington", "Fleming-Harrington 2"), 
			domain="R-RcmdrPlugin.survival"),
		title=gettext("Method", domain="R-RcmdrPlugin.survival"))
	radioButtons(optionsFrame, name="error",
		buttons=c("greenwood", "tsiatis"), initialValue="greenwood",
		labels=gettext(c("Greenwood", "Tsiatis"), domain="R-RcmdrPlugin.survival"), 
		title=gettext("Variance Method", domain="R-RcmdrPlugin.survival"))
	quantilesFrame <- tkframe(optionsFrame)
	quantilesVariable <- tclVar("1")
	quantiles <- tclVar(".25, .5, .75")
	quantilesEntry <- ttkentry(quantilesFrame, width="20", textvariable=quantiles)
#	modelFormula(hasLhs=FALSE)
	markTimeFrame <- tkframe(optionsFrame)
	markTimeBox <- tkcheckbutton(markTimeFrame)
	markTimeValue <- tclVar("1")
	tkconfigure(markTimeBox, variable=markTimeValue)	
	subsetBox()
	tkgrid(getFrame(timeBox), labelRcmdr(survFrame, text="  "), getFrame(eventBox), sticky="sw")
	tkgrid(labelRcmdr(survFrame, text=""))
	tkgrid(getFrame(strataBox), sticky="nw")
	tkgrid(survFrame, sticky="nw")
	tkgrid(labelRcmdr(markTimeFrame, text=gettext("Mark censoring times",
				domain="R-RcmdrPlugin.survival"), fg="blue"), markTimeBox, sticky="nw")
	tkgrid(markTimeFrame)
	tkgrid(labelRcmdr(confidenceFieldFrame, text=gettext("Confidence level", 
				domain="R-RcmdrPlugin.survival"), foreground="blue"), sticky="nw")
	tkgrid(confidenceField, sticky="nw")
	tkgrid(conftypeFrame, labelRcmdr(confidenceFrame, text="          "), plotconfFrame, 
		labelRcmdr(confidenceFrame, text="      "), confidenceFieldFrame, sticky="nw")
	tkgrid(labelRcmdr(top, text=""))
	tkgrid(confidenceFrame, sticky="nw")
	tkgrid(labelRcmdr(quantilesFrame, text=gettext("Quantiles to estimate", 
				domain="R-RcmdrPlugin.survival"), foreground="blue"), sticky="nw")
	tkgrid(quantilesEntry)
	tkgrid(typeFrame, labelRcmdr(optionsFrame, text="  "), errorFrame, 
		labelRcmdr(optionsFrame, text="         "), quantilesFrame, sticky="new")
	tkgrid(labelRcmdr(top, text=""))
	tkgrid(optionsFrame, sticky="nw")
	tkgrid(labelRcmdr(top, text=""))
	tkgrid(subsetFrame, sticky="w")
	tkgrid(labelRcmdr(top, text=""))
	tkgrid(buttonsFrame, sticky="w")
	dialogSuffix(rows=9, columns=1)
}
