:: Returns 0 if prime, 1 otherwise
@echo off
setlocal enabledelayedexpansion enableextensions
set esc=exit /b
if %~1 leq 1 %esc% 1
if %~1 lss 4 %esc% 0
if %~1 equ 5 %esc% 0
call :mod %~1 2
call :mod %~1 3
:: https://www.dostips.com/forum/viewtopic.php?f=3&t=5819&start=15#p43998
2>nul set /a "sq=( x=(%~1)/(11*1024)+40-^!(%~1)*9, x=((%~1)/x+x)/2, x=((%~1)/x+x)/2, x=((%~1)/x+x)/2, x=((%~1)/x+x)/2, x=((%~1)/x+x)/2, x+=(((%~1)-((x-1)*(x-1)+(x+x-1)))>>31))/(1+((%~1)>>31))"
for /l %%i in (5,6,!sq!) do (
    call :mod %~1 %%i
    call :mod %~1 (%%i+2^)
)
%esc% 0

:mod
set /a "t=%~1 %% %~2"
if !t! equ 0 (
(goto) 2>nul || %esc% %= exit code 1; see https://superuser.com/a/1486073 =%
)
