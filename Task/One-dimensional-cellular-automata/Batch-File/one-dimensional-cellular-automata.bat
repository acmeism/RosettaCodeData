@echo off
setlocal enabledelayedexpansion

::THE MAIN THING
call :one-dca __###__##_#_##_###__######_###_#####_#__##_____#_#_#######__
pause>nul
exit /b
::/THE MAIN THING

::THE PROCESSOR
:one-dca
echo.&set numchars=0&set proc=%1

::COUNT THE NUMBER OF CHARS
set bef=%proc:_=_,%
set bef=%bef:#=#,%
set bef=%bef:~0,-1%
for %%x in (%bef%) do set /a numchars+=1

set /a endchar=%numchars%-1
:nextgen
echo.   ^| %proc% ^|
set currnum=0
set newgen=
:editeachchar
	set neigh=0
	set /a testnum2=%currnum%+1
	set /a testnum1=%currnum%-1
	if %currnum%==%endchar% (
		set testchar=!proc:~%testnum1%,1!
		if !testchar!==# (set neigh=1)
	) else (
		if %currnum%==0 (
			set testchar=%proc:~1,1%
			if !testchar!==# (set neigh=1)
		) else (
			set testchar1=!proc:~%testnum1%,1!
			set testchar2=!proc:~%testnum2%,1!
			if !testchar1!==# (set /a neigh+=1)
			if !testchar2!==# (set /a neigh+=1)
		)
	)
	if %neigh%==0 (set newgen=%newgen%_)
	if %neigh%==1 (
		set testchar=!proc:~%currnum%,1!
		set newgen=%newgen%!testchar!
	)
	if %neigh%==2 (
		set testchar=!proc:~%currnum%,1!
		if !testchar!==# (set newgen=%newgen%_) else (set newgen=%newgen%#)
	)
if %currnum%==%endchar% (goto :cond) else (set /a currnum+=1&goto :editeachchar)

:cond
if %proc%==%newgen% (echo.&echo          ...The sample is now stable.&goto :EOF)
set proc=%newgen%
goto :nextgen
::/THE (LLLLLLOOOOOOOOOOOOONNNNNNNNGGGGGG.....) PROCESSOR
