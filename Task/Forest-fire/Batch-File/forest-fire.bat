@echo off
setlocal enabledelayedexpansion

if "%1"=="" (
  call:default
) else (
  call:setargs %*
)

call:createarray
call:fillarray
call:display
echo.
echo  -------------------
echo.

for /l %%i in (1,1,%i%) do (
  echo.
  echo  -------------------
  echo.
  call:evolve
  call:display
)
pause>nul

:default
set m=10
set n=11
set p=50
set f=5
set i=5
exit /b

:setargs
set m=%1
set n=%m%+1
set p=%2
set f=%3
set i=%4
exit /b

:createarray
for /l %%m in (0,1,%n%) do (
  for /l %%n in (0,1,%n%) do (
    set a%%m%%n=0
  )
)
exit /b

:fillarray
for /l %%m in (1,1,%m%) do (
  for /l %%n in (1,1,%m%) do (
    set /a treerandom=!random! %% 101
    if !treerandom! leq %p% set a%%m%%n=T
  )
)
exit /b

:display
for /l %%m in (1,1,%m%) do (
  set "line%%m="
  for /l %%n in (1,1,%m%) do (
    set line%%m=!line%%m! !a%%m%%n!
  )
  set line%%m=!line%%m:0= !
  echo.!line%%m!
)
exit /b

:evolve
for /l %%m in (1,1,%m%) do (
  for /l %%n in (1,1,%m%) do (
    call:nexttick !a%%m%%n! %%m %%n
    set newa%%m%%n=!errorlevel!
  )
)
call:update
exit /b

:nexttick

if %1==0 (
  set /a treerandom=!random! %% 101
  if !treerandom! leq %p% exit /b 1
  exit /b 0
)

if %1==T (
  set /a lowerm=%2-1
  set /a upperm=%2+1
  set /a lowern=%3-1
  set /a uppern=%3+1
  set burn=0
  for /l %%m in (!lowerm!,1,!upperm!) do (
    for /l %%n in (!lowern!,1,!uppern!) do (
      if !a%%m%%n!==# set burn=1
    )
  )
  if !burn!==1 exit /b 2

  set /a burnrandom=!random! %% 101
  if !burnrandom! leq %f% exit /b 2
  exit /b 1
)

if %1==# exit /b 0

:update
for /l %%m in (1,1,%m%) do (
  for /l %%n in (1,1,%m%) do (
    if !newa%%m%%n!==1 set newa%%m%%n=T
    if !newa%%m%%n!==2 set newa%%m%%n=#
    set a%%m%%n=!newa%%m%%n!
  )
)
exit /b
