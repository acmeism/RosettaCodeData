@echo off
:: {CTRL + C} to exit the batch file

:: Send incrementing decimal values to the :to_Oct function
set loop=0
:loop1
call:to_Oct %loop%
set /a loop+=1
goto loop1

:: Convert the decimal values parsed [%1] to octal and output them on a new line
:to_Oct
set todivide=%1
set "fulloct="

:loop2
set tomod=%todivide%
set /a appendmod=%tomod% %% 8
set fulloct=%appendmod%%fulloct%
if %todivide% lss 8 (
  echo %fulloct%
  exit /b
)
set /a todivide/=8
goto loop2
