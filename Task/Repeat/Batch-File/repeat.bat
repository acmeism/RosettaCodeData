@echo off

:_main
setlocal
call:_func1 _func2 3
pause>nul
exit/b

:_func1
setlocal enabledelayedexpansion
for /l %%i in (1,1,%2) do call:%1
exit /b

:_func2
setlocal
echo _func2 has been executed
exit /b
