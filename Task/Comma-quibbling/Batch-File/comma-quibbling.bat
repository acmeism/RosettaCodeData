@echo off
setlocal enabledelayedexpansion

::THE MAIN THING...
echo.
set inp=[]
call :quibble
set inp=["ABC"]
call :quibble
set inp=["ABC","DEF"]
call :quibble
set inp=["ABC","DEF","G","H"]
call :quibble
echo.
pause
exit /b
::/THE MAIN THING...

::THE FUNCTION
:quibble
set cont=0
set proc=%inp:[=%
set proc=%proc:]=%

for %%x in (%proc%) do (
	set /a cont+=1
	set x=%%x
	set str!cont!=!x:"=!
)
set /a bef=%cont%-1
set output=%str1%
if %cont%==2 (set output=%str1% and %str2%)
if %cont% gtr 2 (
	for /l %%y in (2,1,%bef%) do (
		set output=!output!^, !str%%y!
	)
	set output=!output! and !str%cont%!
)
echo {!output!}
goto :EOF
::/THE FUNCTION
