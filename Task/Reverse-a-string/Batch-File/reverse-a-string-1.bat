@echo off
setlocal enabledelayedexpansion
call :reverse %1 res
echo %res%
goto :eof

:reverse
set str=%~1
set cnt=0
:loop
if "%str%" equ "" (
	goto :eof
	)
set chr=!str:~0,1!
set str=%str:~1%
set %2=%chr%!%2!
goto loop
