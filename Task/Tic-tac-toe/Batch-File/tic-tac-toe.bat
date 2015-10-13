::
::Tic-Tac-Toe Task from Rosetta Code Wiki
::Batch File Implementation
::
::Directly OPEN the Batch File to play.
::

@echo off
title Sample TicTacToe Game
mode con cols=50 lines=21
setlocal enabledelayedexpansion

set win=a1a2a3 a4a5a6 a7a8a9 a1a4a7 a2a5a8 a3a6a9 a1a5a9 a3a5a7

:begin
set blanks=123456789&set numblanks=9
for /l %%. in (1,1,9) do set "a%%.= "

set /a rnd=%random%%%2
if %rnd%==1 set msg=YOU will move first.&goto :youmove
set msg=CPU will move first.&goto :rndmove

:youmove
cls
call :display
echo Your Turn:
set "move="
for /F "usebackq delims=" %%L in (`xcopy /L /w "%~f0" "%~f0" 2^>NUL`) do (
  if not defined move set "move=%%L"
)
set move=!move:~-1!
for /l %%. in (1,1,9) do if "!move!"=="%%." goto :preproc
if /i "!move!"=="n" goto :begin
if /i "!move!"=="o" exit
set msg=Invalid Input.
goto youmove

:preproc
if "!a%move%!"=="X" (set msg=An X is already There.&goto youmove)
if "!a%move%!"=="O" (set msg=An O is already There.&goto youmove)

set a%move%=O
set /a numblanks-=1&set blanks=!blanks:%move%=!
call :ifdraw

for %%. in (%win%) do (
		set comb=%%.
		call :mainproc1
)
set block=0
for %%. in (%win%) do (
	if !block!==0 (
		set comb=%%.
		call :mainproc2
	)
)
if %block%==1 (
	set /a numblanks-=1&set blanks=!blanks:%remove%=!
	set msg=CPU Puts an X on Grid %remove%.
	call :ifdraw
	goto youmove
)
goto rndmove


:mainproc1
if "!%comb:~0,2%!!%comb:~2,2%!!%comb:~4,2%!"=="OOO" (set msg=You Win^^!&goto res)

if "!%comb:~0,2%!!%comb:~2,2%!!%comb:~4,2%!"=="XX " (
	set %comb:~4,2%=X&set msg=CPU Wins^^!
	goto res
)
if "!%comb:~0,2%!!%comb:~2,2%!!%comb:~4,2%!"=="X X" (
	set %comb:~2,2%=X&set msg=CPU Wins^^!
	goto res
)
if "!%comb:~0,2%!!%comb:~2,2%!!%comb:~4,2%!"==" XX" (
	set %comb:~0,2%=X&set msg=CPU Wins^^!
	goto res
)
goto :EOF

:mainproc2
if "!%comb:~0,2%!!%comb:~2,2%!!%comb:~4,2%!"=="OO " (
	set %comb:~4,2%=X&set remove=%comb:~5,1%
	set block=1
)
if "!%comb:~0,2%!!%comb:~2,2%!!%comb:~4,2%!"=="O O" (
	set %comb:~2,2%=X&set remove=%comb:~3,1%
	set block=1
)
if "!%comb:~0,2%!!%comb:~2,2%!!%comb:~4,2%!"==" OO" (
	set %comb:~0,2%=X&set remove=%comb:~1,1%
	set block=1
)
goto :EOF

:ifdraw
if %numblanks%==0 (set msg=Game Draw.&goto res)
goto :EOF

:rndmove
set /a rnd=(%random%%%%numblanks%)
set bla=!blanks:~%rnd%,1!
set a%bla%=X
set /a numblanks-=1&set blanks=!blanks:%bla%=!
if not %numblanks%==8 (set msg=CPU Puts an X on Grid %bla%.)
call :ifdraw
goto youmove

:res
cls
call :display
echo Press any char key to play again.
pause>nul
goto begin

:display
echo.
echo             Tic-Tac-Toe  (Man VS CPU)
echo             Batch File Implementation
echo.
echo.
echo         Gameboard           Press:
echo.
echo       +---+---+---+           N - New Game
echo   1-3 ^| %a1% ^| %a2% ^| %a3% ^|           O - Exit
echo       +---+---+---+
echo   4-6 ^| %a4% ^| %a5% ^| %a6% ^|
echo       +---+---+---+           You - O
echo   7-9 ^| %a7% ^| %a8% ^| %a9% ^|           CPU - X
echo       +---+---+---+
echo.
echo Message: !msg!
echo.
goto :EOF
