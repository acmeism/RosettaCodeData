@echo off
setlocal enableDelayedExpansion
if "%~1"=="test" (
  for /l %%. in () do (
    set /a "test1=num %% 2, cnt=cnt+1"
    if !test1! equ 0 (set /a num/=2 & if !num! equ 1 exit !cnt!) else (set /a num=3*num+1)
  )
)

set max=0
set record=0

for /l %%X in (2,1,100000) do (
	set num=%%X & cmd /c "%~f0" test
	if !errorlevel! gtr !max! (set /a "max=!errorlevel!,record=%%X")
)
set /a max+=1

echo.Number less than 100000 with longest sequence: %record%
echo.With length %max%.
pause>nul

exit /b 0
