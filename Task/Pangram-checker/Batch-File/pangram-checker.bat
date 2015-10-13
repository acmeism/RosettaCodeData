@echo off
setlocal enabledelayedexpansion

	%===The Main Thing===%
call :pangram "The quick brown fox jumps over the lazy dog."
call :pangram "The quick brown fox jumped over the lazy dog."
echo.
pause
exit /b 0

	%===The Function===%
:pangram
set letters=abcdefgihjklmnopqrstuvwxyz
set cnt=0
set inp=%~1
set str=!inp: =!

:loop
set chr=!str:~%cnt%,1!
if "!letters!"=="" (
	echo %1 is a pangram^^!
	goto :EOF
)
if "!chr!"=="" (
	echo %1 is not a pangram.
	goto :EOF
)
set letters=!letters:%chr%=!
set /a cnt+=1
goto loop
