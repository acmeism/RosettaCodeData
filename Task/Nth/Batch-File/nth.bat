@echo off
::Main thing...
call :Nth 0 25
call :Nth 250 265
call :Nth 1000 1025
pause
exit /b

::The subroutine
:Nth <lbound> <ubound>
setlocal enabledelayedexpansion
for /l %%n in (%~1,1,%~2) do (
	set curr_num=%%n
	set "out=%%nth"
	if !curr_num:~-1!==1 (set "out=%%nst")
	if !curr_num:~-1!==2 (set "out=%%nnd")
	if !curr_num:~-1!==3 (set "out=%%nrd")
	set "range_output=!range_output! !out!"
)
echo."!range_output:~1!"
goto :EOF
