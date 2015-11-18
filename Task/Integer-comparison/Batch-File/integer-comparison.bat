@echo off
setlocal EnableDelayedExpansion
set /p a="A: "
set /p b="B: "
if %a% LSS %b% (
  echo %a% is less than %b%
) else ( if %a% GTR %b% (
  echo %a% is greater than %b%
) else ( if %a% EQU %b% (
  echo %a% is equal to %b%
)))
