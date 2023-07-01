@echo off
setlocal enabledelayedexpansion
call :length %1 res
echo length of %1 is %res%
goto :eof

:length
set str=%~1
set cnt=0
:loop
if "%str%" equ "" (
	set %2=%cnt%
	goto :eof
	)
set str=!str:~1!
set /a cnt = cnt + 1
goto loop
