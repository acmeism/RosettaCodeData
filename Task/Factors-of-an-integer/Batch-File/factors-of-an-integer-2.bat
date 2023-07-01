@echo off
set /p limit=Gimme a number:
set res=Factors of %limit%:
for /L %%i in (1,1,%limit%) do call :fac %limit% %%i
echo %res%
goto :eof

:fac
set /a test = %1 %% %2
if %test% equ 0 set res=%res% %2
