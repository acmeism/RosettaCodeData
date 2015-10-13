@set @dummy=0 /*
	::Batch File section
	@echo off
	cscript //e:jscript //nologo "%~f0" "%~1"
	exit /b
::*/
//The JScript section
var objVoice = new ActiveXObject("SAPI.SpVoice");
objVoice.speak(WScript.Arguments(0));
