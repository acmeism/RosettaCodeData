@echo off
setlocal enabledelayedexpansion

	%== Initialization ==%
set "male= abe bob col dan ed fred gav hal ian jon"	::First whitespace is necessary
set "female= abi bea cath dee eve fay gay hope ivy jan"	::same here...

	::Initialization of pseudo-arrays [Male]
set "cnt=0" & for %%. in (abi, eve, cath, ivy, jan, dee, fay, bea, hope, gay) do (set abe[!cnt!]=%%.&set /a cnt+=1)
set "cnt=0" & for %%. in (cath, hope, abi, dee, eve, fay, bea, jan, ivy, gay) do (set bob[!cnt!]=%%.&set /a cnt+=1)
set "cnt=0" & for %%. in (hope, eve, abi, dee, bea, fay, ivy, gay, cath, jan) do (set col[!cnt!]=%%.&set /a cnt+=1)
set "cnt=0" & for %%. in (ivy, fay, dee, gay, hope, eve, jan, bea, cath, abi) do (set dan[!cnt!]=%%.&set /a cnt+=1)
set "cnt=0" & for %%. in (jan, dee, bea, cath, fay, eve, abi, ivy, hope, gay) do (set ed[!cnt!]=%%.&set /a cnt+=1)
set "cnt=0" & for %%. in (bea, abi, dee, gay, eve, ivy, cath, jan, hope, fay) do (set fred[!cnt!]=%%.&set /a cnt+=1)
set "cnt=0" & for %%. in (gay, eve, ivy, bea, cath, abi, dee, hope, jan, fay) do (set gav[!cnt!]=%%.&set /a cnt+=1)
set "cnt=0" & for %%. in (abi, eve, hope, fay, ivy, cath, jan, bea, gay, dee) do (set hal[!cnt!]=%%.&set /a cnt+=1)
set "cnt=0" & for %%. in (hope, cath, dee, gay, bea, abi, fay, ivy, jan, eve) do (set ian[!cnt!]=%%.&set /a cnt+=1)
set "cnt=0" & for %%. in (abi, fay, jan, gay, eve, bea, dee, cath, ivy, hope) do (set jon[!cnt!]=%%.&set /a cnt+=1)

	::Initialization of pseudo-arrays [Female]
set "cnt=0" & for %%. in (bob, fred, jon, gav, ian, abe, dan, ed, col, hal) do (set abi[!cnt!]=%%.&set /a cnt+=1)
set "cnt=0" & for %%. in (bob, abe, col, fred, gav, dan, ian, ed, jon, hal) do (set bea[!cnt!]=%%.&set /a cnt+=1)
set "cnt=0" & for %%. in (fred, bob, ed, gav, hal, col, ian, abe, dan, jon) do (set cath[!cnt!]=%%.&set /a cnt+=1)
set "cnt=0" & for %%. in (fred, jon, col, abe, ian, hal, gav, dan, bob, ed) do (set dee[!cnt!]=%%.&set /a cnt+=1)
set "cnt=0" & for %%. in (jon, hal, fred, dan, abe, gav, col, ed, ian, bob) do (set eve[!cnt!]=%%.&set /a cnt+=1)
set "cnt=0" & for %%. in (bob, abe, ed, ian, jon, dan, fred, gav, col, hal) do (set fay[!cnt!]=%%.&set /a cnt+=1)
set "cnt=0" & for %%. in (jon, gav, hal, fred, bob, abe, col, ed, dan, ian) do (set gay[!cnt!]=%%.&set /a cnt+=1)
set "cnt=0" & for %%. in (gav, jon, bob, abe, ian, dan, hal, ed, col, fred) do (set hope[!cnt!]=%%.&set /a cnt+=1)
set "cnt=0" & for %%. in (ian, col, hal, gav, fred, bob, abe, ed, jon, dan) do (set ivy[!cnt!]=%%.&set /a cnt+=1)
set "cnt=0" & for %%. in (ed, hal, gav, abe, bob, jon, col, ian, fred, dan) do (set jan[!cnt!]=%%.&set /a cnt+=1)
	%==/Initialization ==%

(	%== The main thing ==%
echo.HISTORY:
call :stableMatching
echo.
echo.NEWLYWEDS:
call :display
echo.
call :isStable
echo.
echo.What if ed and hal swapped?
call :swapper ed hal
echo.
echo.NEW-NEWLYWEDS:
call :display
echo.
call :isStable
pause>nul
exit /b 0
)	%==/The main thing ==%

	%== The algorithm ==%
:stableMatching
	set "free_men=%male%"		::The free-men variable
	set "free_women=%female%"	::The free-women variable
	set nextgirl=0
:thematchloop
	set m=&for %%F in (!free_men!) do (if not defined m set "m=%%F")
	if "!m!"=="" goto :EOF

	for /f "tokens=1-2 delims==" %%A in ('set !m![!nextgirl!]') do set "w=%%B"
	set "propo="
	for %%W in (!free_women!) do (
		if "%%W"=="!w!" (
			set propo=TRUE
			set "!w!_=!m!" & set "!m!_=!w!"
			set free_women=!free_women: %w%=!
			set free_men=!free_men: %m%=!
			echo.	!w! ACCEPTED !m!.
		)
	)
	if defined propo (set "nextgirl=0" & goto thematchloop)

	for /f "tokens=1-2 delims==" %%A in ('set !w!_') do set "mbef=%%B"
	set "replace=" & for /f "tokens=1-2 delims==" %%R in ('set !w![') do (
		if not defined replace (
			if "%%S"=="!m!" (
				set replace=TRUE
				set "!w!_=!m!" & set "!m!_=!w!"
				set "free_men=!free_men! !mbef!"
				set "free_men=!free_men: %m%=!"
				set nextgirl=0
				echo.	!w! LEFT !mbef!.
				echo.	!w! ACCEPTED !m!.
			)
			if "%%S"=="!mbef!" (
				set /a nextgirl+=1
				set replace=FALSE
			)
		)
	)
goto thematchloop
	%==/The Algorithm ==%

	%== Output the Couples ==%
:display
for %%S in (!male!) do echo.	%%S and !%%S_!.
goto :EOF
	%==/Output the Couples ==%

	%== Stability Checking ==%
:isStable
for %%M in (!female!) do (
	set "better="
	set "dislike=" & for /f "tokens=1-2 delims==" %%R in ('set %%M[') do (
		if not defined dislike (
			if "%%S"=="!%%M_!" (set dislike=T) else (set "better=!better! %%S")
		)
	)
	for %%X in (!better!) do (
		for /f "tokens=1-2 delims==" %%F in ('set %%X_') do set curr_partner_of_boy=%%G
		set "main_check="
		for /f "tokens=1-2 delims==" %%B in ('set %%X[') do (
			if not defined main_check (
				if "%%C"=="%%M" (
					echo.STABILITY = FALSE.
					echo %%M and %%X would rather be together than their current partners.
					goto :EOF
				)
				if "%%C"=="!curr_partner_of_boy!" set "main_check=CONTINUE"
			)
		)
	)
)
echo.STABILITY = TRUE.
goto :EOF
	%==/Stability Chacking ==%

	%== Swapper ==%
:swapper
	set %~1.tmp=!%~1_!
	set %~2.tmp=!%~2_!
	set "%~1_=!%~2.tmp!"
	set "%~2_=!%~1.tmp!"
	set "!%~1.tmp!_=%~2"
	set "!%~2.tmp!_=%~1"
	goto :EOF
	%==/Swapper==%
