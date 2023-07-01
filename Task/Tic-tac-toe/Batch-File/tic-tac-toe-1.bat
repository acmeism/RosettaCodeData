@echo off
setlocal enabledelayedexpansion
:newgame
set a1=1
set a2=2
set a3=3
set a4=4
set a5=5
set a6=6
set a7=7
set a8=8
set a9=9
set ll=X
set /a zz=0
:display1
cls
echo Player: %ll%
echo %a7%_%a8%_%a9%
echo %a4%_%a5%_%a6%
echo %a1%_%a2%_%a3%
set /p myt=Where would you like to go (choose a number from 1-9 and press enter)?
if !a%myt%! equ %myt% (
set a%myt%=%ll%
goto check
)
goto display1
:check
set /a zz=%zz%+1
if %zz% geq 9 goto newgame
if %a7%+%a8%+%a9% equ %ll%+%ll%+%ll% goto win
if %a4%+%a5%+%a6% equ %ll%+%ll%+%ll% goto win
if %a1%+%a2%+%a3% equ %ll%+%ll%+%ll% goto win
if %a7%+%a5%+%a3% equ %ll%+%ll%+%ll% goto win
if %a1%+%a5%+%a9% equ %ll%+%ll%+%ll% goto win
if %a7%+%a4%+%a1% equ %ll%+%ll%+%ll% goto win
if %a8%+%a5%+%a2% equ %ll%+%ll%+%ll% goto win
if %a9%+%a6%+%a3% equ %ll%+%ll%+%ll% goto win
goto %ll%
:X
set ll=O
goto display1
:O
set ll=X
goto display1
:win
echo %ll% wins!
pause
goto newgame
