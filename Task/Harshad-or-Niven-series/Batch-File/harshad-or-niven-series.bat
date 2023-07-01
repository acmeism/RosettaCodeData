@echo off
setlocal enabledelayedexpansion

for /l %%i in (1,1,20) do (
  call:harshad
  echo Harshad number %%i - !errorlevel!
)

:loop
call:harshad
if %errorlevel% leq 1000 goto loop
echo First Harshad number greater than 1000: %errorlevel%
pause>nul
exit /b

:harshad
if "%harshadnum%"=="" set harshadnum=0
set /a harshadnum+=1
call:strlength %harshadnum%

set harshadsum=0
for /l %%i in (0,1,%errorlevel%) do set /a harshadsum+=!harshadnum:~%%i,1!

set /a isharshad=%harshadnum% %% %harshadsum%
if %isharshad%==0 exit /b %harshadnum%
goto harshad

:strlength
setlocal enabledelayedexpansion
set tempcount=1
set str=%1
:strlengthloop
set /a length=%tempcount%-1
if "!str:~%tempcount%,1!"=="" endlocal && exit /b %length%
set /a tempcount+=1
goto strlengthloop
