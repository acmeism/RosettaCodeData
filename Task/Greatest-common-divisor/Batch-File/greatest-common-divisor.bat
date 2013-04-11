:: gcd.cmd
@echo off
:gcd
if "%2" equ "" goto :instructions
if "%1" equ "" goto :instructions

if %2 equ 0 (
	set final=%1
	goto :done
)
set /a res = %1 %% %2
call :gcd %2 %res%
goto :eof

:done
echo gcd=%final%
goto :eof

:instructions
echo Syntax:
echo 	GCD {a} {b}
echo.
