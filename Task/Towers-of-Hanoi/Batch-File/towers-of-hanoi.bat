@echo off
setlocal enabledelayedexpansion

	%==The main thing==%
	%==First param - Number of disks==%
	%==Second param - Start pole==%
	%==Third param - End pole==%
	%==Fourth param - Helper pole==%
call :move 4 START END HELPER
echo.
pause
exit /b 0

	%==The "function"==%
:move
	setlocal
	set n=%1
	set from=%2
	set to=%3
	set via=%4

	if %n% gtr 0 (
		set /a x=!n!-1
		call :move !x! %from% %via% %to%
		echo Move top disk from pole %from% to pole %to%.
		call :move !x! %via% %to% %from%
	)
	exit /b 0
