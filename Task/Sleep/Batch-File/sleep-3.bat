@echo off
set /p Seconds=Enter the number of seconds to sleep:
echo Sleeping ...
timeout /t %Seconds% /nobreak >nul
echo Awake!
