::
::Penney's Game Task from Rosetta Code Wiki
::Batch File Implementation
::
::Please Directly Open the Batch File to play...
::

@echo off
setlocal enabledelayedexpansion
title The Penney's Game Batch File

set cpu=0&set you=0
cls
echo.
echo Penney's Game
echo Batch File Implementation

:main
set you_bet=&set cpu_bet=
echo.&echo --------------------------------------------------------&echo.
echo CPU's Score: %cpu% Your Score: %you%
echo.
<nul set /p "dummy=Heads I start, Tails you start..."
set /a startrnd=%random%%%2
set firsttoss=Tails&set func=optimal
if %startrnd%==1 (set firsttoss=Heads&set func=rndbet)
ping -n 3 localhost >nul
<nul set /p "dummy=.   %firsttoss%^!"
echo.&echo.
goto %func%

:rndbet
set /a "seq1=%random%%%2","seq2=%random%%%2","seq3=%random%%%2"
set binary=%seq1%%seq2%%seq3%
set cpu_bet=%binary:1=H%
set cpu_bet=%cpu_bet:0=T%
echo I will bet first. So, my bet sequence will be %cpu_bet%.
:again1
set /p "you_bet=What will be your bet sequence? "
call :validate again1
echo.&echo So, you're feeling lucky on %you_bet%. We'll see...
goto succesivetossing

:optimal
echo Ok. You will bet first.
:again2
set /p "you_bet=What will be your bet sequence? "
call :validate again2
set seq1=%you_bet:~0,1%&set seq2=%you_bet:~1,1%
set new_seq1=T
if /i %seq2%==T set new_seq1=H
set cpu_bet=%new_seq1%%seq1%%seq2%
echo.&echo Hmm... My bet will be %cpu_bet%. We'll see who's lucky...

:succesivetossing
set toses=&set cnt=0
echo.
<nul set /p "dummy=Tosses:    "
:tossloop
call :tossgen
<nul set /p dummy=%toss%
ping -n 2 localhost >nul
set /a newline=%cnt%%%60
if %newline%==59 (
echo.
<nul set /p "dummy=.          "
)
if "%toses:~-3,3%"=="%cpu_bet%" goto iwin
if "%toses:~-3,3%"=="%you_bet%" goto uwin
set /a cnt+=1&goto tossloop

:tossgen
set /a rand=%random%%%2
set toss=T
if %rand%==0 set toss=H
set toses=%toses%%toss%
goto :EOF

:iwin
set /a cpu+=1&set newgame=
echo.&echo.
echo I Win^^! Better Luck Next Time...
echo.
set /p "newgame=[Type Y if U Wanna Beat Me, or Else, Exit...] "
if /i "!newgame!"=="Y" goto :main
exit

:uwin
set /a you+=1&set newgame=
echo.&echo.
echo Argh, You Win^^! ...But One Time I'll Beat You.
echo.
set /p "newgame=[Type Y for Another Game, or Else, Exit...] "
if /i "!newgame!"=="Y" goto :main
exit

:validate
echo "!you_bet!"|findstr /r /c:"^\"[hHtT][hHtT][hHtT]\"$">nul || (
	echo [Invalid Input...]&echo.&goto %1
)
if /i "!you_bet!"=="%cpu_bet%" (echo [Bet something different...]&echo.&goto %1)
for %%i in ("t=T" "h=H") do set "you_bet=!you_bet:%%~i!"
goto :EOF
