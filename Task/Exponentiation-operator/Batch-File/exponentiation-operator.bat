@echo off
setlocal enableextensions enabledelayedexpansion
set /p a=
set /p b=
call :pow %a% %b%
echo %_a%
goto :eof
:pow Integer Integer
:: Right-to-left binary exponentiation
set /a "_a=1, s=%1, e=%2"
:looppow
if %e% neq 0 (
set /a "t=e&1"
if !t! equ 1 (set /a "_a*=s")
set /a "s*=s, e>>=1"
goto looppow
)
goto :eof
