::
::Number Reversal Game Task from Rosetta Code Wiki
::Batch File Implementation
::
::Please do not open this from command prompt.
::Directly Open the Batch File to play...
::

@echo off
setlocal enabledelayedexpansion
title Number Reversal Game

:begin
set score=0

::The ascending list of 9 digits
set list=123456789


::Generating a random set of 9 digits...
set cyc=9
:gen
set /a tmp1=%random%%%%cyc%
set n%cyc%=!list:~%tmp1%,1!
set tmp2=!n%cyc%!
set list=!list:%tmp2%=!
if not %cyc%==2 (
	set /a cyc-=1
	goto :gen
)
set /a n1=%list%

::Display the Game
cls
echo.
echo ***Number Reversal Game***
:loopgame
echo.
echo Current arrangement: %n1%%n2%%n3%%n4%%n5%%n6%%n7%%n8%%n9%
set /p move=How many digits from the left should I reverse?

::Reverse digits according to the player's input
::NOTE: The next command uses the fact that in Batch File,
::The output for the division operation is only the integer part of the quotient.
set /a lim=(%move%+1)/2

set cyc2=1
:reverse
set /a tmp4=%move%-%cyc2%+1
set tmp5=!n%cyc2%!
set n%cyc2%=!n%tmp4%!
set n%tmp4%=%tmp5%
if not %cyc2%==%lim% (
	set /a cyc2+=1
	goto :reverse
)

::Increment the number of moves took by the player
set /a score+=1

::IF already won...
if %n1%%n2%%n3%%n4%%n5%%n6%%n7%%n8%%n9%==123456789 (
	echo.
	echo Set: %n1%%n2%%n3%%n4%%n5%%n6%%n7%%n8%%n9% DONE^^!
	echo You took %score% moves to arrange the numbers in ascending order.
	pause>nul
	exit
) else (
goto :loopgame
)
