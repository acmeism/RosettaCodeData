@echo off
setlocal enableextensions enabledelayedexpansion
if defined sigintEnd goto timerCalc
if defined sigintMain goto main
set timer=for /f "tokens=1-4 delims=:.," %%a in ("^!time^!"^) do set start_h=%%a^&set /a start_m=100%%b %% 100^&set /a start_s=100%%c %% 100^&set /a start_ms=100%%d %% 100
(
%timer%
set sigintMain=1
%= "echo y" to skip a prompt and proceed to time reporting =%
echo y| cmd /d /c "%~f0"
cmd /d /c set sigintEnd=1^&"%~f0"
goto :eof
)
:main
set i=1
:loop
echo %i%
:: sleep for 1 second
ping 0.0.0.0 -n 2 >nul
set /a i+=1
goto loop
:timerCalc
%timer:start=end%
for %%i in (h m s ms) do set /a %%i=end_%%i-start_%%i
if %ms% lss 0 set /a s-=1 & set /a ms=100%ms%
if %s% lss 0 set /a m-=1 & set /a s=60%s%
if %m% lss 0 set /a h-=1 & set /a m=60%m%
if %h% lss 0 set /a h=24%h%
if 1%ms% lss 100 set ms=0%ms%
set /a totalsecs=h*3600 + m*60 +s
echo Execution time: %totalsecs%.%ms%s
