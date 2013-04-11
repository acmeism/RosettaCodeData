@echo off
set /p MilliSeconds=Enter the number of milliseconds to sleep:
echo Sleeping ...
ping -n 1 -w %MilliSeconds% 1.2.3.4 >nul 2>&1
echo Awake!
