::Pancake Sort
::Batch File Implementation
::
::Using the "Classic XOR trick" to swap integer values of two variables...
::...IF the variable names are different...

@echo off
setlocal enabledelayedexpansion

::Initial Values and Variables
set "range=0"
set "output="
set "list=-2 0 -1 5 2 7 4 3 6 -1 7 2 1 8"
	::Put the sequence of integers (ONLY) on the list variable.
	::Please do not "play" with the list variable.
	::or else the code will not work or crash.

for %%l in (!list!) do (
	set num!range!=%%l
	set /a range+=1
)
set /a range-=1

::Scramble
for /l %%l in (%range%,-1,1) do (
	set /a n=^(%random% %% %%l^)
	set /a num%%l^^^^=num!n!
	set /a num!n!^^^^=num%%l
	set /a num%%l^^^^=num!n!
)
::/Scramble (Remove this if you do not want to scramble the integers)

::Display initial condition
for /l %%l in (0,1,%range%) do set "output=!output!  !num%%l!"
echo.Initial Sequence:
echo.
echo.       ^>^> !output!
echo.
echo Sorting:
echo.

	::Sort begins!
for /l %%m in (%range%,-1,1) do (
	set n=0
	for /l %%l in (1,1,%%m) do (
		set /a tmp_var1=num!n!
		if !tmp_var1! lss !num%%l! set n=%%l
	)
	if !n! lss %%m (
		if !n! gtr 0 (
			set /a tmp_var1=!n!/2
			for /l %%l in (0,1,!tmp_var1!) do (
				set /a tmp_var2=!n!-%%l
				if !tmp_var2! neq %%l (
					set /a num!tmp_var2!^^^^=num%%l
					set /a num%%l^^^^=num!tmp_var2!
					set /a num!tmp_var2!^^^^=num%%l
				)
			)
			set output=
			for /l %%x in (0,1,%range%) do set "output=!output!  !num%%x!"
			echo.       ^>^> !output!
		)
		set /a tmp_var3=%%m/2
		for /l %%l in (0,1,!tmp_var3!) do (
			set /a tmp_var4=%%m-%%l
			if !tmp_var4! neq %%l (
				set /a num!tmp_var4!^^^^=num%%l
				set /a num%%l^^^^=num!tmp_var4!
				set /a num!tmp_var4!^^^^=num%%l
			)
		)
			set output=
			for /l %%x in (0,1,%range%) do set "output=!output!  !num%%x!"
			echo.       ^>^> !output!
		)
	)
	
)
	::We are done.
	echo DONE^^!
	exit /b 0
