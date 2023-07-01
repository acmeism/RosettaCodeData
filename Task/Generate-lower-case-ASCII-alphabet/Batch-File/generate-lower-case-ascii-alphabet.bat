@echo off
setlocal enabledelayedexpansion

:: This code appends the ASCII characters from 97-122 to %alphabet%, removing any room for error.

for /l %%i in (97,1,122) do (
  cmd /c exit %%i
  set "alphabet=!alphabet! !=exitcodeAscii!"
)
echo %alphabet%
pause>nul
