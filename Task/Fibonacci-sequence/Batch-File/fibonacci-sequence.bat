::fibo.cmd
@echo off
if "%1" equ "" goto :eof
call :fib %1
echo %errorlevel%
goto :eof

:fib
setlocal enabledelayedexpansion
if %1 geq 2 goto :ge2
exit /b %1

:ge2
set /a r1 = %1 - 1
set /a r2 = %1 - 2
call :fib !r1!
set r1=%errorlevel%
call :fib !r2!
set r2=%errorlevel%
set /a r0 = r1 + r2
exit /b !r0!
