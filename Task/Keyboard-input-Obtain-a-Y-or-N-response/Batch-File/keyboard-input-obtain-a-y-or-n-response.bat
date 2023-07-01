@echo off
choice
if errorlevel 2 echo You chose N
if errorlevel 1 echo You chose Y
>nul pause
