@echo off
:num2bin    IntVal [RtnVar]
  setlocal enableDelayedExpansion
  set /a n=%~1
  set rtn=
  for /l %%b in (0,1,31) do (
    set /a "d=n&1, n>>=1"
    set rtn=!d!!rtn!
  )
  for /f "tokens=* delims=0" %%a in ("!rtn!") do set rtn=%%a
  (endlocal & rem -- return values
    if "%~2" neq "" (set %~2=%rtn%) else echo %rtn%
  )
exit /b
