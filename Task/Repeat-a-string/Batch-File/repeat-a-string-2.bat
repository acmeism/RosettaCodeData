@echo off
set /p a=Enter string to repeat :
set /p b=Enter how many times to repeat :
set "c=1"
set "d=%b%"
:a
echo %a%
set "c=%c%+=1"
if /i _"%c%"==_"%d%" (exit /b)
goto :a
