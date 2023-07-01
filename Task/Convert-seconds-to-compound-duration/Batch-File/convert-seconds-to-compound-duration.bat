@echo off
::The Main Thing...
for %%d in (7259 86400 6000000) do call :duration %%d
exit/b 0
::/The Main Thing.

::The Function...
:duration
	set output=
	set /a "wk=%1/604800,rem=%1%%604800"
	if %wk% neq 0 set "output= %wk% wk,"

	set /a "d=%rem%/86400,rem=%rem%%%86400"
	if %d% neq 0 set "output=%output% %d% d,"

	set /a "hr=%rem%/3600,rem=%rem%%%3600"
	if %hr% neq 0 set "output=%output% %hr% hr,"

	set /a "min=%rem%/60,rem=%rem%%%60"
	if %min% neq 0 set "output=%output% %min% min,"

	if %rem% neq 0 set "output=%output% %rem% sec,"

	if %1 gtr 0 echo %1 sec = %output:~1,-1%
	goto :EOF
::/The Function.
