@echo off
setlocal enabledelayedexpansion

set /p pairs=

for /l %%i in (1,1,%pairs%) do set /p pair%%i=
for /l %%i in (1,1,%pairs%) do (
  for %%j in (!pair%%i!) do (
    set /a sum%%i+=%%j
  )
)

for /l %%i in (1,1,%pairs%) do echo !sum%%i!
pause>nul
