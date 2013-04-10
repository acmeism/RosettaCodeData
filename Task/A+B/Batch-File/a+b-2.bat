::aplusb.cmd
@echo off
setlocal
set a=%1
set b=%2
set /a c=a+b
echo %c%
endlocal
