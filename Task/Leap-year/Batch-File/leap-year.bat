@echo off

::The Main Thing...
for %%x in (1900 2046 2012 1600 1800 2031 1952) do (
	call :leap %%x
)
echo.
pause
exit/b
::/The Main Thing...

::The Function...
:leap
set year=%1
set /a op1=%year%%%4
set /a op2=%year%%%100
set /a op3=%year%%%400
if not "%op1%"=="0" (goto :no)
if not "%op2%"=="0" (goto :yes)
if not "%op3%"=="0" (goto :no)
:yes
echo.
echo %year% is a leap year.
goto :EOF
:no
echo.
echo %year% is NOT a leap year.
goto :EOF
::/The Function...
