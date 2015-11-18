::
::Bulls and Cows Task from Rosetta Code Wiki
::Batch File Implementation
::
::Directly OPEN the Batch File to play...
::

@echo off
title Bulls and Cows Game
setlocal enabledelayedexpansion

::GENERATING THE CODE TO BE GUESSED BY PLAYER...
:begin
set list=123456789
set cnt=1
set code=
set tries=0
:gen
set /a mod=10-%cnt%
set /a rnd=%random%%%%mod%
set pick=!list:~%rnd%,1!
set code=%code%%pick%
set list=!list:%pick%=!
if %cnt%==4 (
	set c1=%code:~0,1%&set c2=%code:~1,1%&set c3=%code:~2,1%&set c4=%code:~3,1%
	goto :start
)
set /a cnt+=1
goto :gen
::/GENERATING THE CODE TO BE GUESSED BY PLAYER...

::GAME DISPLAY
:start
cls
echo.
echo Bulls and Cows Game
echo Batch File Implementation
echo.
echo NOTE: Please MAXIMIZE this command window.
echo.
echo Gameplay:
echo.
echo I have generated a 4-digit code from digit 1-9 WITHOUT duplication.
echo Your objective is to guess it. If your guess is equal to my code,
echo then you WIN. If not, I will score your guess:
echo.
echo ** A score of one BULL is accumulated for each digit that equals
echo the CORRESPONDING digit in my code.
echo.
echo ** A score of one COW is accumulated for each digit that appears
echo in your guess, but in the WRONG position.
echo.
echo Now, start guessing^^!
echo.
:game
echo.
set /p guess=Your Guess:
::/GAME DISPLAY

::INPUT VALIDATION
if !guess! gtr 9876 (echo Please input a valid guess.&goto :game)
if !guess! lss 1234 (echo Please input a valid guess.&goto :game)
set i1=%guess:~0,1%&set i2=%guess:~1,1%&set i3=%guess:~2,1%&set i4=%guess:~3,1%
set chk=1
:cycle
set /a tmp1=%chk%+1
for /l %%a in (%tmp1%,1,4) do (
	if !i%chk%!==!i%%a! (
		echo Please input a valid guess.&goto :game
	)
)
if %chk%==3 (
	goto :score
)
set /a chk+=1
goto :cycle
::/INPUT VALIDATION

::SCORING
:score
set /a tries+=1
if %guess%==%code% (goto :won)
set cow=0
set bull=0
for /l %%a in (1,1,4) do (
	if !i%%a!==!c%%a! (
		set /a bull+=1
	) else (
		set "entrycow=%%a"
		call :scorecow
	)
)
set guess=
echo BULLS=%bull% COWS=%cow%
goto :game

:scorecow
set nums=1 2 3 4
set put=!nums:%entrycow%=!
for %%b in (%put%) do (
	if !c%%b!==!i%entrycow%! (
		set /a cow+=1
		goto :EOF
	)
)
goto :EOF
::/SCORING

::ALREADY WON!
:won
echo.
echo.
echo After %tries% Tries, YOU CRACKED IT^^! My code is %code%.
echo.
set /p opt=Play again?(Y/N)
if /i "!opt!"=="y" (call :begin)
if /i "!opt!"=="n" (exit/b)
goto :won
::/ALREADY WON!
