@echo off
setlocal enabledelayedexpansion

	%== Initializations ==%
set width=50
set height=30

set /a allowance=height+2
mode %width%,%allowance%
echo Rendering...

set "outp="
for /l %%i in (1,1,%height%) do (
	for /l %%j in (1,1,%width%) do (
		set "c[%%i][%%j]= "
	)
)

	%== Set the parameters for making circle ==%
call :DrawCircle 20 20 10
call :DrawCircle 10 30 15

	%== Output result ==%
for /l %%i in (1,1,%height%) do (
	for /l %%j in (1,1,%width%) do (
		set "outp=!outp!!c[%%i][%%j]!"
	)
)
cls
echo !outp!
pause>nul
exit /b

	%== The main function ==%
:DrawCircle
	set x0=%1
	set y0=%2
	set radius=%3

	set x=!radius!
	set y=0
	set /a decisionOver2 = 1 - !x!

	:circle_loop
	if !x! geq !y! (
		set /a "hor=x + x0","ver=y + y0"
		set "c[!hor!][!ver!]=Û"
		set /a "hor=y + x0","ver=x + y0"
		set "c[!hor!][!ver!]=Û"
		set /a "hor=-x + x0","ver=y + y0"
		set "c[!hor!][!ver!]=Û"
		set /a "hor=-y + x0","ver=x + y0"
		set "c[!hor!][!ver!]=Û"
		set /a "hor=-x + x0","ver=-y + y0"
		set "c[!hor!][!ver!]=Û"
		set /a "hor=-y + x0","ver=-x + y0"
		set "c[!hor!][!ver!]=Û"
		set /a "hor=x + x0","ver=-y + y0"
		set "c[!hor!][!ver!]=Û"
		set /a "hor=y + x0","ver=-x + y0"
		set "c[!hor!][!ver!]=Û"

		set /a y+=1
		if !decisionOver2! leq 0 (
			set /a "decisionOver2 = !decisionOver2! + (2 * y^) + 1"
		) else (
			set /a x-=1
			set /a "decisionOver2 = !decisionOver2! + 2 * (y - x^) + 1"
		)
		goto circle_loop
	)
goto :EOF
