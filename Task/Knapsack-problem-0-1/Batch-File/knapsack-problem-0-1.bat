:: Initiate command line environment
@echo off
setlocal enabledelayedexpansion

:: Establish arrays we'll be using
set items=map compass water sandwich glucose tin banana apple cheese beer suntancream camera tshirt trousers umbrella waterprooftrousers waterproofoverclothes notecase sunglasses towel socks book
set weight=9 13 153 50 15 68 27 39 23 52 11 32 24 48 73 42 43 22 7 18 4 30
set importance=150 35 200 160 60 45 60 40 30 10 70 30 15 10 40 70 75 80 20 12 50 10

:: Put the above 3 arrays into their own variables with the form of "item[]", "w[]" and "i[]"
set tempnum=0
for %%i in (%items%) do (
  set /a tempnum+=1
  set item!tempnum!=%%i
)
set tempnum=0
for %%i in (%weight%) do (
  set /a tempnum+=1
  set w!tempnum!=%%i
)
set tempnum=0
for %%i in (%importance%) do (
  set /a tempnum+=1
  set i!tempnum!=%%i
)
:: Define the array "r[]" as the ratio between the importance ("i[]") and the weight ("w[]").
for /l %%i in (1,1,22) do set /a r%%i=!i%%i!*100/!w%%i! & rem batch doesn't support decimals, so the numerator is multiplied by 100 to get past this

set totalimportance=0
set totalweight=0
set amount=0

:: Find the largest number in "r[]" and define some temp variables based off it
:load
set tempr=0
set tempitem=0
for /l %%i in (1,1,22) do (
  if !r%%i! gtr !tempr! (
    set tempr=!r%%i!
    set tempitem=%%i
    set /a testweight=%totalweight%+!w%%i!
    if !tempr!==0 goto end
    if !testweight! geq 400 goto end
  )
)

:: Do basic error checking using the temp variables from above and either output and end the program or send back to load
set /a totaltempweight=%totalweight%+!w%tempitem%!

if %totaltempweight% gtr 400 (
  set !r%tempitem%!=0
  goto load
)

set totalweight=%totaltempweight%
set /a totalimportance+=!i%tempitem%!
set taken=%taken% !item%tempitem%!
set /a amount+=1
set r%tempitem%=0 & rem set the ratio variable of the item we just added to the knapsack as 0 to stop it repeat

goto load

:end
echo List of things taken [%amount%]: %taken%
echo Total Value: %totalimportance%  Total Weight: %totalweight%
pause>nul
