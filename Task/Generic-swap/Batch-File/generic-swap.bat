@echo off
setlocal enabledelayedexpansion
set a=1
set b=woof
echo %a%
echo %b%
call :swap a b
echo %a%
echo %b%
goto :eof

:swap
set temp1=!%1!
set temp2=!%2!
set %1=%temp2%
set %2=%temp1%
goto :eof
