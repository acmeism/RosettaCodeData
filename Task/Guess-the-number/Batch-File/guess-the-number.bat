@echo off
set /a answer=%random%%%(10-1+1)+1
set /p guess=Pick a number between 1 and 10:
:loop
if %guess%==%answer% (echo Well guessed!
pause) else (set /p guess=Nope, guess again:
goto loop)
