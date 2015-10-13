@echo off
setlocal enabledelayedexpansion

	::Set the inputs
set "code=17/91 78/85 19/51 23/38 29/33 77/29 95/23 77/19 1/17 11/13 13/11 15/14 15/2 55/1"
set "n=2"

	::Basic validation of code
for %%. in (!code!) do (
	echo.%%.|findstr /r /c:"^[0-9][0-9]*/[1-9][0-9]*$">nul||goto error_code
)
	::Validate the input
set /a "tst=1*!n!" 2>nul
if !tst! lss 0 goto error_input
if !tst! equ 0 (if not "!n!"=="0" (goto error_input))

	::Set the limit outputs
	set limit=20

	::Execute the code
echo.Input:
echo.	!n!
echo.Output:
for /l %%? in (1,1,!limit!) do (
	set shouldwehalt=1
	for %%A in (!code!) do (
		for /f "tokens=1,2 delims=/" %%B in ("%%A") do (
			set /a "tst=!n! %% %%C"
			if !tst! equ 0 (
				if !shouldwehalt! equ 1 (
					set shouldwehalt=0
					set /a "n=n*%%B/%%C"
					echo.	!n!
				)
			)
		)
	)
	if !shouldwehalt! equ 1 goto halt
)

:halt
echo.
pause
exit /b 0

:error_code
echo.Syntax error in code.
echo.
pause
exit /b 1

:error_input
echo.Invalid input.
echo.
pause
exit /b 1
