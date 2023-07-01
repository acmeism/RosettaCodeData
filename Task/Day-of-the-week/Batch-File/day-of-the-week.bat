:: Day of the Week task from Rosetta Code
:: Batch File Implementation
:: Question: In what years between 2008 and 2121 will the 25th of December be a Sunday?
:: Method: Zeller's Rule

@echo off
rem set month code for December
set mon=33
rem set day number
set day=25

for /L %%y in (2008,1,2121) do (
   setlocal enabledelayedexpansion
   set /a "a=%%y/100"
   set /a "b=%%y-(a*100)"
   set /a "weekday=(day+mon+b+(b/4)+(a/4)+(5*a))%%7"
   if "!weekday!"=="1" echo(Dec 25, %%y is a Sunday.
   endlocal
)
pause
exit /b 0
