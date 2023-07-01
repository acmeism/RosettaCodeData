::args2.cmd
@echo off
setlocal enabledelayedexpansion
set fn=%~f0
set p0=%~0
set p*=%*
set /a c=1
:loop
if @%1==@ goto done
	set p%c%=%~1
	set /a c=c+1
	shift
	goto loop
:done
set /a c=c-1
set p#=%c%
echo fn=%fn%
echo p0=%p0%
echo p*=%p*%
echo p#=%p#%
for /l %%i in (1,1,%p#%) do (
	echo p%%i=!p%%i!
)
