@echo off

call:horners a:-19 b:7 c:-4 d:6 x:3
call:horners x:3 a:-19 c:-4 d:6 b:7
pause>nul
exit /b

:horners
setlocal enabledelayedexpansion
set a=0
set b=0
set c=0
set d=0
set x=0

for %%i in (%*) do (
  for /f "tokens=1,2 delims=:" %%j in ("%%i") do (
    set %%j=%%k
  )
)
set /a return=((((0)*%x%+%d%)*%x%+(%c%))*%x%+%b%)*%x%+(%a%)
echo %return%
exit /b
