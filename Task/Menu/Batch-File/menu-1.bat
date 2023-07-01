@echo off & setlocal enabledelayedexpansion

set "menuChoices="fee fie","huff and puff","mirror mirror","tick tock""

call :menu

pause>nul & exit


:menu
	if defined menuChoices (
		set "counter=0" & for %%a in (%menuChoices%) do (
			set /a "counter+=1"
			set "currentMenuChoice=%%a"
			set option[!counter!]=!currentMenuChoice:"=!
		)
	)
:tryagain
cls&echo.
for /l %%a in (1,1,%counter%) do echo %%a^) !option[%%a]!
echo.
set /p "input=Choice 1-%counter%: "
echo.
for /l %%a in (1,1,%counter%) do (
	if !input! equ %%a echo You chose [ %%a^) !option[%%a]! ] & goto :EOF
)
echo.
echo.Invalid Input. Please try again...
pause
goto :tryagain
