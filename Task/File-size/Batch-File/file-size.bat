@echo off
if not exist "%~1" exit /b 1 & rem If file doesn't exist exit with error code of 1.
for /f %%i in (%~1) do echo %~zi
pause>nul
