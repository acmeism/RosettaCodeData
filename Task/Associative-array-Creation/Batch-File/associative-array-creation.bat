::assocarrays.cmd
@echo off
setlocal ENABLEDELAYEDEXPANSION
set array.dog=1
set array.cat=2
set array.wolf=3
set array.cow=4
for %%i in (dog cat wolf cow) do call :showit array.%%i !array.%%i!
set c=-27
call :mkarray sicko flu 5 measles 6 mumps 7 bromodrosis 8
for %%i in (flu measles mumps bromodrosis) do call :showit "sicko^&%%i" !sicko^&%%i!
endlocal
goto :eof

:mkarray
set %1^&%2=%3
shift /2
shift /2
if "%2" neq "" goto :mkarray
goto :eof

:showit
echo %1 = %2
goto :eof
