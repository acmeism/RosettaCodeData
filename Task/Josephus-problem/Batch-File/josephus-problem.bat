@echo off
setlocal enabledelayedexpansion

set "prison=41"		%== Number of prisoners ==%
set "step=3"		%== The step... ==%
set "survive=1"		%== Number of survivors ==%
call :josephus

set "prison=41"
set "step=3"
set "survive=3"
call :josephus
pause
exit /b 0

	%== The Procedure ==%
:josephus
set "surv_list="
for /l %%S in (!survive!,-1,1) do (
	set /a "m = %%S - 1"
	for /l %%X in (%%S,1,!prison!) do (
		set /a "m = (m + step) %% %%X"
	)
	if defined surv_list (
		set "surv_list=!surv_list! !m!"
	) else (
		set "surv_list=!m!"
	)
)
echo !surv_list!
goto :EOF
