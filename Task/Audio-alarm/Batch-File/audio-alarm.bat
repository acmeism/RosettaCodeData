@echo off

:: Get user input
:: %alarm% can have spaces, but cannot have quotation marks ("")
:: %time% has a working range of -1 to 99999 seconds
:input
set /p "time=Input amount of time in seconds to wait: "
set /p "alarm=Input name of alarm: "

:: Check if %time% is an integer with 'set /a'
set /a intcheck=%time%
if %intcheck%==0 goto input

cls
timeout /t %time% /nobreak >nul
start "" "%alarm%.mp3"
