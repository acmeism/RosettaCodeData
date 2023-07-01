@echo off

echo Fibonacci Sequence:
call:nfib 1 1
echo.

echo Tribonacci Sequence:
call:nfib 1 1 2
echo.

echo Tetranacci Sequence:
call:nfib 1 1 2 4
echo.

echo Lucas Numbers:
call:nfib 2 1
echo.

pause>nul
exit /b

:nfib
setlocal enabledelayedexpansion

for %%i in (%*) do (
  set /a count+=1
  set seq=!seq! %%i
)
set "seq=%seq% ^| "
set n=-%count%
set /a n+=1
for %%i in (%*) do (
  set F!n!=%%i
  set /a n+=1
)

for /l %%i in (1,1,10) do (
  set /a termstart=%%i-%count%%
  set /a termend=%%i-1
  for /l %%j in (!termstart!,1,!termend!) do (
    set /a F%%i+=!F%%j!
  )
  set seq=!seq! !F%%i!
)
echo %seq%

endlocal
exit /b
