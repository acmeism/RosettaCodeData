@echo off
setlocal enabledelayedexpansion

set /p lines=

for /l %%i in (1,1,%lines%) do set /p line%%i=
cls
for /l %%i in (1,1,%lines%) do echo !line%%i!
pause>nul
