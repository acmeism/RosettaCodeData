::arrays.cmd
@echo off
setlocal ENABLEDELAYEDEXPANSION
set array.1=1
set array.2=2
set array.3=3
set array.4=4
for /L %%i in (1,1,4) do call :showit array.%%i !array.%%i!
set c=-27
call :mkarray marry 5 6 7 8
for /L %%i in (-27,1,-24) do call :showit "marry^&%%i" !marry^&%%i!
endlocal
goto :eof

:mkarray
set %1^&%c%=%2
set /a c += 1
shift /2
if "%2" neq "" goto :mkarray
goto :eof

:showit
echo %1 = %2
goto :eof
