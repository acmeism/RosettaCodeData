::
::Digital Root Task from Rosetta Code Wiki
::Batch File Implementation
::
::Base 10...
::

@echo off
setlocal enabledelayedexpansion

::THE MAIN THING...
for %%x in (9876543214 393900588225 1985989328582 34559) do (
	call :droot %%x
)
echo.
pause
exit /b
::/THE MAIN THING...

::THE FUNCTION
:droot
set inp2sum=%1&set persist=1

:cyc1
set sum=0
set scan_digit=0
:cyc2
set digit=!inp2sum:~%scan_digit%,1!
if "%digit%"=="" (goto :sumdone)
set /a sum+=%digit%
set /a scan_digit+=1
goto :cyc2

:sumdone
if %sum% lss 10 (
	echo.
	echo ^(%1^)
	echo Additive Persistence=%persist% Digital Root=%sum%.
	goto :EOF
)
set /a persist+=1
set inp2sum=%sum%
goto :cyc1
::/THE FUNCTION
