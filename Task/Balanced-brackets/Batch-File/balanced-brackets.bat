:: Balanced Brackets Task from Rosetta Code Wiki
:: Batch File Implementation

@echo off
setlocal enabledelayedexpansion

::The Main Thing...
set numofpairs=10
set howmanystrings=10
cls
for /l %%. in (1,1,%howmanystrings%) do (
	call :generate
	call :checkforbalance
)
echo.&pause&exit /b
::/The Main Thing.

::Generate strings of brackets...
:generate
	set i=0&set j=%numofpairs%&set samp=
	set /a toss=%random%%%2
	set put1=[&set put2=]
	if %toss%==1 (set put1=]&set put2=[)
	for /l %%x in (1,1,%numofpairs%) do (
		set samp=!samp!%put1%
	)
	:add
	if not %i%==%numofpairs% (
		set /a rnd=%random%%%%j%+1
		set /a oppos=%j%-!rnd!
		::A new trick for substitution of delayed variables...
		for /f "tokens=1-2" %%A in ("!rnd! !oppos!") do (
			set str1=!samp:~-%%A!
			set str2=!samp:~0,%%B!
		)
		set samp=!str2!%put2%!str1!
		set /a "j+=1","i+=1"
		goto :add
	)
goto :EOF
::/Generate strings of brackets.

::Check for Balance...
::Uses Markov Algorithm.
:checkforbalance
set "changes=!samp!"
:check_loop
if "!changes!"=="" goto itsbal
if "!input!"=="!changes!" goto notbal

set input=!changes!
set "changes=!input:[]=!"
goto check_loop

:itsbal
echo.
echo %samp% is Balanced.
goto :EOF
:notbal
echo.
echo %samp% is NOT Balanced.
goto :EOF
::/Check for Balance.
