@echo off
setlocal enabledelayedexpansion
call :tokenize %1 res
echo %res%
goto :eof

:tokenize
set str=%~1
:loop
for %%i in (%str%) do set %2=!%2!.%%i
set %2=!%2:~1!
goto :eof
