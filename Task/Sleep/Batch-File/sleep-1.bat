@echo off
set /p Seconds=Enter the number of seconds to sleep:
set /a Seconds+=1
echo Sleeping ...
ping -n %Seconds% localhost >nul 2>&1
echo Awake!
