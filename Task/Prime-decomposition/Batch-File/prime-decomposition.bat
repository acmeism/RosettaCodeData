@echo off
::usage: cmd /k primefactor.cmd number
setlocal enabledelayedexpansion

set /a compo=%1
if "%compo%"=="" goto:eof
set list=%compo%= (

set /a div=2 & call :loopdiv
set /a div=3 & call :loopdiv
set /a div=5,inc=2

:looptest
call :loopdiv
set /a div+=inc,inc=6-inc,div2=div*div
if %div2% lss %compo% goto looptest
if %compo% neq 1 set list= %list% %compo%
echo %list%)   & goto:eof

:loopdiv
set /a "res=compo%%div
if %res% neq 0 goto:eof
set list=%list% %div%,
set/a compo/=div
goto:loopdiv
