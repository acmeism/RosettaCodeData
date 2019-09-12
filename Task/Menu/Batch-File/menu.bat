@echo off

call:menu "fee fie" "huff and puff" "mirror mirror" "tick tock"
pause>nul
exit /b

:menu
cls
setlocal enabledelayedexpansion
set count=0
set reset=endlocal ^& goto menu
:menuloop
for %%i in (%*) do (
	set /a count+=1
	set string[!count!]=%%~i
	echo string[!count!] = %%~i
)
echo.
set /p choice=^>
if "%choice%"=="" %reset%
set "isNum="
for /f "delims=0123456789" %%i in ("%choice%") do set isNum=%%i
if defined isNum %reset%
if %choice% gtr %count% %reset%
echo.!string[%choice%]!
goto:eof
