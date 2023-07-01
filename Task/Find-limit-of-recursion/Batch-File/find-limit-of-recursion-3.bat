@echo off
set c=0
:mung
set /a c=c+1
echo [Level %c%] Mung until no good
call :mung
set /a c=c-1
echo [Level %c%] No good
