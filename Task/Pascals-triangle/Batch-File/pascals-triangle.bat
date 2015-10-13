@echo off
setlocal enabledelayedexpansion

::The Main Thing...
cls
echo.
set row=15
call :pascal
echo.
pause
exit /b 0
::/The Main Thing.

::The Functions...
:pascal
	set /a prev=%row%-1
	for /l %%I in (0,1,%prev%) do (
		set c=1&set r=
		for /l %%K in (0,1,%row%) do (
			if not !c!==0 (
				call :numstr !c!
				set r=!r!!space!!c!
			)
			set /a c=!c!*^(%%I-%%K^)/^(%%K+1^)
		)
		echo !r!
	)
goto :EOF

:numstr
	::This function returns the number of whitespaces to be applied on each numbers.
	set cnt=0&set proc=%1&set space=
	:loop
	set currchar=!proc:~%cnt%,1!
	if not "!currchar!"=="" set /a cnt+=1&goto loop
	set /a numspaces=5-!cnt!
	for /l %%A in (1,1,%numspaces%) do set "space=!space! "
goto :EOF
::/The Functions.
