@echo off
setlocal enabledelayedexpansion

for /l %%i in (1,1,9999) do (
  title Processing - %%i
  call:kaprekar %%i
)

pause>nul
exit /b

:kaprekar
set num=%1
if %num% leq 0 exit /b
set /a num2=%num%*%num%

if %num2% leq 9 (
  if %num2%==%num% (
    echo %num%
    exit /b
  ) else (
    exit /b
  )
)

call:strlength %num2%
set len=%errorlevel%
set /a offset=%len%-1
set tempcount=1

:loop

set /a offset2=%len%-%tempcount%
set numleft=!num2:~0,%tempcount%!
set numright=!num2:~%tempcount%,%offset2%!

for /f "tokens=* delims=0" %%i in ("%numright%") do set "numright=%%i"
if not defined numright exit /b
set /a sum=%numleft%+%numright%

if %sum%==%num% (
  echo %num%
  exit /b
)

if %tempcount%==%len% exit /b
set /a tempcount+=1
goto loop

:strlength
setlocal enabledelayedexpansion
set str=%1
set tempcount=1
:lengthloop
set /a length=%tempcount%-1
if "!str:~%tempcount%,1!"=="" exit /b %tempcount%
set /a tempcount+=1
goto lengthloop
