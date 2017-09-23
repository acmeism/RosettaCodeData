@echo off
setlocal enabledelayedexpansion

:_main

for /l %%i in (1,1,20000) do (

  echo Processing %%i

  call:_P %%i
  set Pn=!errorlevel!
  if !Pn! lss %%i set /a deficient+=1
  if !Pn!==%%i set /a perfect+=1
  if !Pn! gtr %%i set /a abundant+=1
  cls
)

echo Deficient - %deficient% ^| Perfect - %perfect% ^| Abundant - %abundant%
pause>nul


:_P
setlocal enabledelayedexpansion
set sumdivisers=0

set /a upperlimit=%1-1

for /l %%i in (1,1,%upperlimit%) do (
  set /a isdiviser=%1 %% %%i
  if !isdiviser!==0 set /a sumdivisers+=%%i
)

exit /b %sumdivisers%
