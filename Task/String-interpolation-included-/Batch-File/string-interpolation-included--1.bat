@echo off
setlocal enabledelayedexpansion
call :interpolate %1 %2 res
echo %res%
goto :eof

:interpolate
set pat=%~1
set str=%~2
set %3=!pat:X=%str%!
goto :eof
