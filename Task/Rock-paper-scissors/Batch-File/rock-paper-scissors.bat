@echo off
setlocal enabledelayedexpansion

set choice1=rock
set choice2=paper
set choice3=scissors
set freq1=0
set freq2=0
set freq3=0
set games=0
set won=0
set lost=0
set tie=0

:start
cls
echo Games - %games% : Won - %won% : Lost - %lost% : Ties - %tie%
choice /c RPS /n /m "[R]ock, [P]aper or [S]cissors? "

set choice=%errorlevel%
rem used [1,1000] as interval for random
if %games% equ 0 (
    rem at the beginning, there's no bias for each choice
    set /a "rocklimit=1000 / 3"
    set /a "scissorslimit=1000 * 2 / 3"
) else (
    set /a "rocklimit=1000 * %freq3% / %games%"
    set /a "scissorslimit=1000 * (%freq1% + %freq3%) / %games%"
)
set /a "randchoice=%random% %% 1000 + 1"
set compchoice=2
if %randchoice% geq %scissorslimit% set compchoice=3
if %randchoice% leq %rocklimit% set compchoice=1

cls
echo Player: !choice%choice%! ^|vs^| Computer: !choice%compchoice%!
goto %compchoice%

:1
if %choice%==1 goto tie
if %choice%==2 goto win
if %choice%==3 goto loss

:2
if %choice%==1 goto loss
if %choice%==2 goto tie
if %choice%==3 goto win

:3
if %choice%==1 goto win
if %choice%==2 goto loss
if %choice%==3 goto tie

:win
set /a "won+=1"
echo Player wins^!
goto end

:loss
set /a "lost+=1"
echo Computer Wins^!
goto end

:tie
set /a "tie+=1"
echo Tie^!
goto end

:end
set /a "games+=1"
set /a "freq%choice%+=1"
pause
goto start
