::aplusb.cmd
@echo off
setlocal
set /p a="A: "
set /p b="B: "
set /a c=a+b
echo %c%
endlocal
