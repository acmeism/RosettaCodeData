@echo off
:: Pick 2 random, non-zero, 2-digit numbers to send to :_main
set /a param1=%random% %% 98 + 1
set /a param2=%random% %% 98 + 1
call:_main %param1% %param2%
pause>nul
exit /b

:: This is the main function that outputs the answer in the form of "%1 * %2 = %answer%"
:_main
setlocal enabledelayedexpansion
set l0=%1
set r0=%2
set leftcount=1
set lefttempcount=0
set rightcount=1
set righttempcount=0

:: Creates an array ("l[]") with the :_halve function. %l0% is the initial left number parsed
:: This section will loop until the most recent member of "l[]" is equal to 0
:left
set /a lefttempcount=%leftcount%-1
if !l%lefttempcount%!==1 goto right
call:_halve !l%lefttempcount%!
set l%leftcount%=%errorlevel%
set /a leftcount+=1
goto left

:: Creates an array ("r[]") with the :_double function, %r0% is the initial right number parsed
:: This section will loop until it has the same amount of entries as "l[]"
:right
set /a righttempcount=%rightcount%-1
if %rightcount%==%leftcount% goto both
call:_double !r%righttempcount%!
set r%rightcount%=%errorlevel%
set /a rightcount+=1
goto right

:both
:: Creates an boolean array ("e[]") corresponding with whether or not the respective "l[]" entry is even
for /l %%i in (0,1,%lefttempcount%) do (
  call:_even !l%%i!
  set e%%i=!errorlevel!
)

:: Adds up all entries of "r[]" based on the value of "e[]", respectively
set answer=0
for /l %%i in (0,1,%lefttempcount%) do (
  if !e%%i!==1 (
    set /a answer+=!r%%i!
  :: Everything from this-----------------------------
    set iseven%%i=KEEP
  ) else (
    set iseven%%i=STRIKE
  )
  echo L: !l%%i! R: !r%%i! - !iseven%%i!
  :: To this, is for cosmetics and is optional--------

)
echo %l0% * %r0% = %answer%
exit /b

:: These are the three functions being used. The output of these functions are expressed in the errorlevel that they return
:_halve
setlocal
set /a temp=%1/2
exit /b %temp%

:_double
setlocal
set /a temp=%1*2
exit /b %temp%

:_even
setlocal
set int=%1
set /a modint=%int% %% 2
exit /b %modint%
