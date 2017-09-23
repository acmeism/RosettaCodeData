@echo off

call:floyd 5
echo.
call:floyd 14
pause>nul
exit /b

:floyd
setlocal enabledelayedexpansion
set iterations=%1
set startn=1
set endn=1

for /l %%i in (1,1,%iterations%) do (
  for /l %%j in (!startn!,1,!endn!) do (
    set lastnum=%%j
    set /a startn=%%j+1
  )
  set /a endn=!startn!+%%i
)

call:getlength %startn%
set digits=%errorlevel%

set startn=1
set endn=1

for /l %%i in (1,1,%iterations%) do (
  set "line="
  for /l %%j in (!startn!,1,!endn!) do (
    set "space="
    call:getlength %%j
    set /a sparespace=%digits%-!errorlevel!
    for /l %%k in (0,1,!sparespace!) do set "space=!space! "

    set line=!line!!space!%%j
    set /a startn=%%j+1
  )
  echo !line!
  set /a endn=!startn!+%%i
)
exit /b

:getlength
setlocal enabledelayedexpansion
set offset=0
set string=%1
:floydloop
if "!string:~%offset%,1!"=="" endlocal && exit /b %offset%
set /a offset+=1
goto floydloop
