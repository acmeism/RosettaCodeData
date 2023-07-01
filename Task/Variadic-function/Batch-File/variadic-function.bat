@echo off

:_main
call:_variadicfunc arg1 "arg 2" arg-3
pause>nul

:_variadicfunc
setlocal
for %%i in (%*) do echo %%~i
exit /b

:: Note: if _variadicfunc was called from cmd.exe with arguments parsed to it, it would only need to contain:
::  @for %%i in (%*) do echo %%i
