::max.cmd
@echo off
setlocal enabledelayedexpansion
set a=.%~1
if "%a%" equ "." set /p a="Input stream: "
call :max res %a%
echo %res%
endlocal
goto :eof

:max
set %1=%2
:loop
shift /2
if "%2" equ "" goto :eof
if %2 gtr !%1! set res=%2
goto loop
