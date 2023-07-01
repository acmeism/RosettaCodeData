@echo off
setlocal enabledelayedexpansion

set "extensions=.zip .rar .7z .gz .archive .A##"

:loop
if "%~1"=="" exit /b
set onlist=0

for %%i in (%extensions%) do if /i "%~x1"=="%%i" set onlist=1

if %onlist%==1 (
  echo Filename: "%~1" ^| Extension: "%~x1" ^| TRUE
) else (
  echo Filename: "%~1" ^| Extension: "%~x1" ^| FALSE
)

shift
goto loop
