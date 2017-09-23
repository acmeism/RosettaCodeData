@echo off
set number=0
:loop
set /a number+=1
echo %number%
goto loop
