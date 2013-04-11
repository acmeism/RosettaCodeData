@echo off
set res=Factors of %1:
for /L %%i in (1,1,%1) do call :fac %1 %%i
echo %res%
goto :eof

:fac
set /a test = %1 %% %2
if %test% equ 0 set res=%res% %2
