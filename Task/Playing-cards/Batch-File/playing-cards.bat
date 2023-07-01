@echo off
setlocal enabledelayedexpansion

call:newdeck deck
echo new deck:
echo.
call:showcards deck
echo.
echo shuffling:
echo.
call:shuffle deck
call:showcards deck
echo.
echo dealing 5 cards to 4 players
call:deal deck 5 hand1 hand2 hand3 hand4
echo.
echo player 1 & call:showcards hand1
echo.
echo player 2 & call:showcards hand2
echo.
echo player 3 & call:showcards hand3
echo.
echo player 4 & call:showcards hand4
echo.
call:count %deck% cnt
echo %cnt% cards remaining in the deck
echo.
 call:showcards deck
echo.

exit /b

:getcard deck hand  :: deals 1 card to a player
   set "loc1=!%~1!"
   set "%~2=!%~2!!loc1:~0,3!"
   set "%~1=!loc1:~3!"
exit /b

:deal deck n player1 player2...up to 7
 set "loc=!%~1!"
 set "cards=%~2"
 set players=%3 %4 %5 %6 %7 %8 %9
 for /L %%j in (1,1,!cards!) do (
     for %%k in (!players!) do call:getcard loc %%k)
 set "%~1=!loc!"
 exit /b

:newdeck  [deck]   ::creates a deck of cards
 :: in the parentheses below there are ascii chars 3,4,5 and 6 representing the suits
 for %%i in ( ♠ ♦ ♥ ♣ ) do (
   for %%j in (20 31 42 53 64 75 86 97 T8 J9 QA KB AC) do set loc=!loc!%%i%%j
   )
 set "%~1=!loc!"
exit /b

:showcards  [deck]  :: prints a deck or a hand
 set "loc=!%~1!"
  for /L %%j in (0,39,117) do (
     set s=
     for /L %%i in (0,3,36) do (
        set /a n=%%i+%%j
        call set  s=%%s%% %%loc:~!n!,2%%
      )
  if "!s: =!" neq "" echo(!s!
  set /a n+=1
  if "%loc:~!n!,!%" equ "" goto endloop
  )
 :endloop
 exit /b

:count deck count
set "loc1=%1"
set /a cnt1=0
for %%i in (96 48 24 12 6 3 ) do if "!loc1:~%%i,1!" neq "" set /a cnt1+=%%i & set loc1=!loc1:~%%i!
set /a cnt1=cnt1/3+1
set "%~2=!cnt1!"
exit /b

:shuffle (deck)   :: shuffles a deck
 set "loc=!%~1!"
 call:count %loc%, cnt
 set /a cnt-=1
 for /L %%i in (%cnt%,-1,0) do (
    SET /A "from=%%i,to=(!RANDOM!*(%%i-1)/32768)"
	call:swap loc from to
  )
  set "%~1=!loc!"
 exit /b

 :swap deck from to   :: swaps two cards
    set "arr=!%~1!"
    set /a "from=!%~2!*3,to=!%~3!*3"
	set temp1=!arr:~%from%,3!
    set temp2=!arr:~%to%,3!
    set arr=!arr:%temp1%=@@@!
    set arr=!arr:%temp2%=%temp1%!
    set arr=!arr:@@@=%temp2%!
	set "%~1=!arr!"
 exit /b
