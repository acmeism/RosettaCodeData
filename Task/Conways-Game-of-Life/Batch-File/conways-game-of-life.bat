@echo off
setlocal enabledelayedexpansion

if "%1"=="" (
  call:_blinkerArray
) else (
  call:_randomArray %*
)

for /l %%i in (1,1,%iterations%) do (
  call:_setStatus
  call:_display

  for /l %%m in (1,1,%m%) do (
    for /l %%n in (1,1,%m%) do (
      call:_evolution %%m %%n
    )
  )
)

:_blinkerArray
for /l %%m in (0,1,4) do (
  for /l %%n in (0,1,4) do (
    set cell[%%m][%%n]=0
  )
)
set cell[2][1]=1
set cell[2][2]=1
set cell[2][3]=1
set iterations=5
set m=3
set cellsaddone=4

exit /b

:_randomArray
set cellsaddone=%1+1
for /l %%m in (0,1,%cellsaddone%) do for /l %%n in (0,1,%cellsaddone%) do set cell[%%m][%%n]=0
for /l %%m in (1,1,%1) do (
  for /l %%n in (1,1,%1) do (
    set /a cellrandom=!random! %% 101
    set cell[%%m][%%n]=0
    if !cellrandom! leq %2 set cell[%%m][%%n]=1
  )
)
set iterations=%3
set m=%1

exit /b

:_setStatus
for /l %%m in (0,1,%cellsaddone%) do (
  for /l %%n in (0,1,%cellsaddone%) do (
    if !cell[%%m][%%n]!==1 set cellstatus[%%m][%%n]=alive
    if !cell[%%m][%%n]!==0 set cellstatus[%%m][%%n]=dead
  )
)
exit /b


:_evolution
set /a lowerm=%1-1
set /a upperm=%1+1
set /a lowern=%2-1
set /a uppern=%2+1
set numm=%1
set numn=%2
set sum=0
for /l %%m in (%lowerm%,1,%upperm%) do (
  for /l %%n in (%lowern%,1,%uppern%) do (
    if %%m==%numm% (
      if %%n==%numn% (
        set /a sum=!sum!
      ) else (
        if !cellstatus[%%m][%%n]!==alive set /a sum+=1
      )
    ) else (
      if !cellstatus[%%m][%%n]!==alive set /a sum+=1
    )
  )
)
goto:!cell[%numm%][%numn%]!

exit /b

:0
set alive=3
set death=0 1 2 4 5 6 7 8
for %%i in (%alive%) do if %sum%==%%i set cell[%numm%][%numn%]=1
for %%i in (%death%) do if %sum%==%%i set cell[%numm%][%numn%]=0
exit /b

:1
set alive=2 3
set death=0 1 4 5 6 7 8
for %%i in (%alive%) do if %sum%==%%i set cell[%1][%2]=1
for %%i in (%death%) do if %sum%==%%i set cell[%1][%2]=0
exit /b

:_display
echo.
for /l %%m in (1,1,%m%) do (
  set m%%m=
  for /l %%n in (1,1,%m%) do set m%%m=!m%%m! !cell[%%m][%%n]!
  echo !m%%m!
)

exit /b
