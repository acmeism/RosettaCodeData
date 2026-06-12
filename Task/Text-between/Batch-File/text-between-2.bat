@echo off
::: Parameters: [input file]
if "%~1"=="" (echo Parameters: [input file]& goto :eof)

:: Delete test?.txt
if not exist test?.txt goto main
echo Delete&dir /b test?.txt&choice
if not %errorlevel%==1 goto :eof
del test?.txt

:main
setlocal enabledelayedexpansion
set i=0
set file=1
for /f "delims=: tokens=1*" %%a in ('type %1 ^| find /v "Example"') do (
if "!i!"=="4" (
  set i=0
  set /a file+=1
)
>>test!file!.txt echo%%b
set /a i+=1
)

echo Successfully created
dir /b test?.txt
