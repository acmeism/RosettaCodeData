@echo off
setlocal enabledelayedexpansion
set ret=1
for /l %%i in (20, -1, 11) do call :lcm !ret! %%i
echo !ret!
goto :eof

:lcm
call :gcd %1 %2
set /a ret=%1*%2/!a!
goto :eof

:gcd
set a=%1
set b=%2
:gcdloop
if !b! neq 0 (
    set /a t=b, b=a%%b, a=t
    goto :gcdloop
)
goto :eof
