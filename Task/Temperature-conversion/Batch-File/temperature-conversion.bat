@echo off
setlocal enableextensions enabledelayedexpansion
set /p n=
set "tempstr=%n:.= %"
call :assignnum %tempstr%
set /a res=n         & call :disp K
set /a res-=27315    & call :disp C
set /a res=(res*18+32000)/10 & call :disp F
set /a res=res+45967 & call :disp R
goto:eof

:assignnum
set tempstr=%2
if not defined tempstr goto:setzero
2>nul set /a tempstr=%tempstr:~0,2%||goto:setzero
set /a "n=tempstr%%10"
if "%n%"=="%tempstr%" set tempstr=0%tempstr%
:_assign
set /a n=%1%tempstr%
goto:eof

:setzero
set tempstr=00
goto :_assign

:disp
echo %1  %res:~0,-2%.%res:~-2%
goto:eof
