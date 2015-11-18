@echo off
set /a dummy=5/0 2>nul

if %errorlevel%==1073750993 echo I caught a division by zero operation...
exit /b 0
