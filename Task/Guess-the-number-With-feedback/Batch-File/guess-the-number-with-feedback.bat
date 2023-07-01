@echo off

:A
set /a number=%random% %% 10 + 1
:B
set /p guess=Choose a number between 1 and 10:
if %guess equ %number% goto win
if %guess% gtr 10 msg * "Number must be between 1 and 10."
if %guess% leq 0 msg * "Number must be between 1 and 10."
if %guess% gtr %number% echo Higher!
if %guess% lss %number% echo Lower!
goto B
:win
cls
echo You won! The number was %number%
pause>nul
goto A
