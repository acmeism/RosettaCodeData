@echo off
setlocal enabledelayedexpansion

:: Define arrays of days/months we'll need
set daynames=Monday Tuesday Wednesday Thursday Friday Saturday Sunday
set monthnames=January February March April May June July August September October November December

:: Separate the output of the 'date /t' command (outputs in the format of "Sun 16/04/2017") into 4 variables
for /f "tokens=1,2,3,4 delims=/ " %%i in ('date /t') do (
  set dayname=%%i
  set day=%%j
  set month=%%k
  set year=%%l
)

:: Crosscheck the first 3 letters of every word in %daynames% to the 3 letter day name found previously
for %%i in (%daynames%) do (
  set tempdayname=%%i
  set comparedayname=!tempdayname:~0,3!
  if "%dayname%"=="!comparedayname!" set fulldayname=%%i
)

:: Variables starting with "0" during the 'set /a' command are treated as octal numbers. To avoid this, if the first character of %month% is "0", it is removed
if "%month:~0,1%"=="0" set monthtemp=%month:~1,1%
set monthcount=0

:: Iterates through %monthnames% and when it reaches the amount of iterations dictated by %month%, sets %monthname% as the current month being iterated through
for %%i in (%monthnames%) do (
  set /a monthcount+=1
  if %monthtemp%==!monthcount! set monthname=%%i
)

echo %year%-%month%-%day%
echo %fulldayname%, %monthname% %day%, %year%
pause>nul
