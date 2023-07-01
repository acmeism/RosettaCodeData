@echo off
set c=0
:mung
set /a c=%1+1
if %c%==10 goto :eof
echo [Level %c%] Mung until no good
call :mung %c%
set /a c=%1-1
echo [Level %c%] No good
