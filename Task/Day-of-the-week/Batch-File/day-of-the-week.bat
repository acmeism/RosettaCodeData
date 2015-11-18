:: Day of the Week task from Rosetta Code Wiki
:: Batch File Implementation
::
:: In what years between 2008 and 2121 will the 25th of December be a Sunday?
::
:: This implementation uses Zeller's Rule...

@echo off

::Set month code for December
set mon=33

::Set day number
set day=25

for /L %%w in (2008,1,2121) do (
call :check_day %%w
)
pause>nul
exit /b

:check_day
set yr=%1
set /a a=%yr%/100
set /a b=%yr%-(%a%*100)
set /a weekday=(%day%+%mon%+%b%+(%b%/4)+(%a%/4)+(5*%a%))%%7
if %weekday%==1 (
echo Dec 25, %yr% is a Sunday.
)
goto :EOF
