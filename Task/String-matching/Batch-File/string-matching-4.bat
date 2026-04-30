@echo off
setlocal enableextensions enabledelayedexpansion
set /p a=
set /p b=
call :getres startsWith.bat "%a%" "%b%"
echo "%a%" starts with "%b%": %result%
call :getres endsWith.bat "%a%" "%b%"
echo "%a%" ends with "%b%": %result%
set idx=
call indexOf.bat "%a%" "%b%" idx
echo "%a%" contains "%b%" at: %idx%
goto:eof

:getres
call %1 %2 %3 && set result=No||set result=Yes
goto:eof
