@echo off
setlocal
:main
for /L %%i in (99,-1,1) do (
	call :verse %%i
)
echo no bottles of beer on the wall
echo no bottles of beer
echo go to the store and buy some more
echo 99 bottles of beer on the wall
echo.
set /p q="Keep drinking? "
if %q% == y goto main
if %q% == Y goto main
goto :eof

:verse
call :plural %1 res
echo %res% of beer on the wall
echo %res% of beer
call :oneit %1 res
echo take %res% down and pass it round
set /a c=%1-1
call :plural %c% res
echo %res% of beer on the wall
echo.
goto :eof

:plural
if %1 gtr 1 goto :gtr
if %1 equ 1 goto :equ
set %2=no bottles
goto :eof
:gtr
set %2=%1 bottles
goto :eof
:equ
set %2=1 bottle
goto :eof

:oneit
if %1 equ 1 (
	set %2=it
) else (
	set %2=one
)
goto :eof
