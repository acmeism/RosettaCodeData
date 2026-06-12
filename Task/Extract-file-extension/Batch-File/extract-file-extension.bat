@echo off

:loop
if "%~1"=="" exit /b
echo File Path: "%~1" ^| File Extension "%~x1"
shift
goto loop
