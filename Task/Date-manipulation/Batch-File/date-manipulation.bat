@echo off

call:Date_Manipulation "March 7 2009 7:30pm EST"
call:Date_Manipulation "February 28 2009 2:28pm EST"
call:Date_Manipulation "February 29 2000 9:52pm EST"
pause>nul
exit /b

:Date_Manipulation
setlocal enabledelayedexpansion

:: These are the arrays we'll be using
set daysinmonth=31 28 31 30 31 30 31 31 30 31 30 31
set namesofmonths=January February March April May June July August September October November December

:: Separate the date given ("%1") into respective variables. Note: For now the "am/pm" is attached to %minutes%
for /f "tokens=1,2,3,4,5,6 delims=: " %%i in ("%~1") do (
  set monthname=%%i
  set day=%%j
  set year=%%k
  set hour=%%l
  set minutes=%%m
  set timezone=%%n
)

:: Separate the am/pm and the minutes value into different variables
set ampm=%minutes:~2,2%
set minutes=%minutes:~0,2%

:: Check if the day needs to be changed based on the status of "am/pm"
if %ampm%==pm (
  set /a day+=1
  set ampm=am
) else (
  set ampm=pm
)

:: Get the number corresponding to the month given
set tempcount=0
for %%i in (%namesofmonths%) do (
  set /a tempcount+=1
  if %monthname%==%%i set monthcount=!tempcount!
)

:: As this step may may be needed to repeat if the month needs to be changed, we add a label here
:getdaysinthemonth
:: Work out how many days are in the current month
set tempcount=0
for %%i in (%daysinmonth%) do (
  set /a tempcount+=1
  if %monthcount%==!tempcount! set daysinthemonth=%%i
)

:: If the month is February, check if it is a leap year. If so, add 1 to the amount of days in the month
if %daysinthemonth%==28 (
  set /a leapyearcheck=%year% %% 4
  if !leapyearcheck!==0 set /a daysinthemonth+=1
)

:: Check if the month needs to be changed based on the current day and how many days there are in the current month
if %day% gtr %daysinthemonth% (
  set /a monthcount+=1
  set day=1
  if !monthcount! gtr 12 (
    set monthcount=1
    set /a year+=1
  )
  goto getdaysinthemonth
)
:: Everything from :getdaysinthemonth will be repeated once if the month needs to be changed

:: This block is only required to change the name of the month for the output, however as you have %monthcount%, this is optional
set tempcount=0
for %%i in (%namesofmonths%) do (
  set /a tempcount+=1
  if %monthcount%==!tempcount! set monthname=%%i
)

echo Original    - %~1
echo Manipulated - %monthname% %day% %year% %hour%:%minutes%%ampm% %timezone%
exit /b
