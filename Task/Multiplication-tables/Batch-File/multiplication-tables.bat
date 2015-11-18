@echo off
setlocal enabledelayedexpansion

::The Main Thing...
cls
set colum=12&set row=12
call :multable
echo.
pause
exit /b 0
::/The Main Thing.

::The Functions...
:multable
	echo.
	for /l %%. in (1,1,%colum%) do (
	call :numstr %%.
	set firstline=!firstline!!space!%%.
	set seconline=!seconline!-----
	)
	echo !firstline!
	echo !seconline!

	::The next lines here until the "goto :EOF" prints the products...

	for /l %%X in (1,1,%row%) do (
		for /l %%Y in (1,1,%colum%) do (
			if %%Y lss %%X (set "line%%X=!line%%X!     ") else (
				set /a ans=%%X*%%Y
				call :numstr !ans!
				set "line%%X=!line%%X!!space!!ans!"
			)
		)
		echo.!line%%X! ^| %%X
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
