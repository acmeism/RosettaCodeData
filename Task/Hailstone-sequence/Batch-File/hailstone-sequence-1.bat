@echo off
setlocal enabledelayedexpansion
echo.
::Task #1
call :hailstone 111
echo Task #1: (Start:!sav!)
echo !seq!
echo.
echo Sequence has !cnt! elements.
echo.
::Task #2
call :hailstone 27
echo Task #2: (Start:!sav!)
echo !seq!
echo.
echo Sequence has !cnt! elements.
echo.
pause>nul
exit /b 0

::The Function
:hailstone
set num=%1
set seq=%1
set sav=%1
set cnt=0

:loop
set /a cnt+=1
if !num! equ 1 goto :eof
set /a isodd=%num%%%2
if !isodd! equ 0 goto divideby2

set /a num=(3*%num%)+1
set seq=!seq! %num%
goto loop

:divideby2
set /a num/=2
set seq=!seq! %num%
goto loop
