@echo off
setlocal enabledelayedexpansion

call :equilibrium-index "-7 1 5 2 -4 3 0"
call :equilibrium-index "2 4 6"
call :equilibrium-index "2 9 2"
call :equilibrium-index "1 -1 1 -1 1 -1 1"
pause>nul
exit /b

	%== The Function ==%
:equilibrium-index <sequence with quotes>
	::Set the pseudo-array sequence...
set "seq=%~1"
set seq.length=0
for %%S in (!seq!) do (
	set seq[!seq.length!]=%%S
	set /a seq.length+=1
)
	::Initialization of other variables...
set "equilms="
set /a last=seq.length - 1
	::The main checking...
for /l %%e in (0,1,!last!) do (
	set left=0
	set right=0

	for /l %%i in (0,1,!last!) do (
		if %%i lss %%e (set /a left+=!seq[%%i]!)
		if %%i gtr %%e (set /a right+=!seq[%%i]!)
	)
	if !left!==!right! (
		if defined equilms (
			set "equilms=!equilms! %%e"
		) else (
			set "equilms=%%e"
		)
	)
)
echo [!equilms!]
goto :EOF
	%==/The Function ==%
