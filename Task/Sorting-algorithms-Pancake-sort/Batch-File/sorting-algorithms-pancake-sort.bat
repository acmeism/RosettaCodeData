:: Pancake Sort from Rosetta Code
:: Batch File Implementation

@echo off
setlocal enabledelayedexpansion

:: put the input sequence of integers (only) on the list variable.
set "list=-2 0 -1 5 2 7 4 3 6 -1 7 2 1 8"

:: create a pseudo-array; start at 0.
set "range=-1"
for %%l in (%list%) do (
	set /a "range+=1"
	set "num!range!=%%l"
)

:: scramble (remove this if you do not want to scramble the integers)
for /l %%l in (%range%,-1,1) do (
	set /a "n=%random% %% %%l"
	rem swapping...
	for %%? in (num!n!) do set "swaptemp=!%%?!"
	set "num!n!=!num%%l!"
	set "num%%l=!swaptemp!"
)

:: display initial condition
set "output="
for /l %%l in (0,1,%range%) do set "output=!output!  !num%%l!"
echo(Initial Sequence:
echo(
echo(       ^>^> %output%
echo(
echo(Sorting:
echo(

:: begin sort
for /l %%l in (%range%,-1,1) do (
	set "n=0"
	for /l %%m in (1,1,%%l) do (
		for %%? in (num!n!) do if !%%?! lss !num%%m! set "n=%%m"
	)

	if !n! lss %%l (
		if !n! gtr 0 (
			set /a "tempvar1=!n!/2" %==  corresponds to (n \ 2) from BASIC code ==%
			for /l %%m in (0,1,!tempvar1!) do (
				set /a "tempvar2=!n!-%%m" %==  corresponds to (n - L0) from BASIC code ==%
				rem swapping...
				for %%? in (num!tempvar2!) do set "swaptemp=!%%?!"
				set "num!tempvar2!=!num%%m!"
				set "num%%m=!swaptemp!"
			)
			rem display the action
			set "output="
			for /l %%x in (0,1,%range%) do set "output=!output!  !num%%x!"
			echo(       ^>^> !output!
		)

		set /a "tempvar1=%%l/2" %==  corresponds to (L1 \ 2) from BASIC code ==%
		for /l %%m in (0,1,!tempvar1!) do (
			set /a "tempvar2=%%l-%%m" %==  corresponds to (L1 - L0) from BASIC code ==%
			rem swapping...
			for %%? in (num!tempvar2!) do set "swaptemp=!%%?!"
			set "num!tempvar2!=!num%%m!"
			set "num%%m=!swaptemp!"
		)
		rem display the action
		set output=
		for /l %%x in (0,1,%range%) do set "output=!output!  !num%%x!"
		echo.       ^>^> !output!
		)
	)

)

echo DONE^^!
exit /b 0
