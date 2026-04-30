@echo off
setlocal enableextensions
set /p ab=
call :setab %ab%
set /a res=a+b
echo %res%
goto:eof

:setab
set a=%1
set b=%2
goto:eof
