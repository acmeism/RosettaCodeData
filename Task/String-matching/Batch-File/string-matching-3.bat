@echo off
setlocal enableextensions enabledelayedexpansion
set /p a=
set /p b=
set "macroset=(set contain.M=Yes) else (set contain.M=No)"
:: https://ss64.com/nt/syntax-replace.html
call set "t=%%a:%b%=#%%"
if "#"=="%t:~0,1%" %macroset:M=0%
call set "t=%%a:*%b%=%%"
if ""=="%t%" %macroset:M=1%
call set "t=%%a:%b%=%%"
if not "%a%"=="%t%" %macroset:M=2%
echo "%a%" starts with "%b%": %contain.0%
echo "%a%" ends with "%b%": %contain.1%
echo "%a%" contains "%b%": %contain.2%
