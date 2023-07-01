@echo off
set /a c=c+1
echo [Depth %c%] Mung until no good
cmd /c mung.cmd
echo [Depth %c%] No good
set /a c=c-1
