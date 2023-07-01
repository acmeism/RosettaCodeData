::Draw a Clock Task from Rosetta Code Wiki
::Batch File Implementation
::
::Directly open the Batch File...
@echo off & mode 44,8
title Sample Batch Clock
setlocal enabledelayedexpansion
chcp 65001

	::Set the characters...
set "#0_1=█████"
set "#0_2=█   █"
set "#0_3=█   █"
set "#0_4=█   █"
set "#0_5=█████"

set "#1_1=    █"
set "#1_2=    █"
set "#1_3=    █"
set "#1_4=    █"
set "#1_5=    █"

set "#2_1=█████"
set "#2_2=    █"
set "#2_3=█████"
set "#2_4=█    "
set "#2_5=█████"

set "#3_1=█████"
set "#3_2=    █"
set "#3_3=█████"
set "#3_4=    █"
set "#3_5=█████"

set "#4_1=█   █"
set "#4_2=█   █"
set "#4_3=█████"
set "#4_4=    █"
set "#4_5=    █"

set "#5_1=█████"
set "#5_2=█    "
set "#5_3=█████"
set "#5_4=    █"
set "#5_5=█████"

set "#6_1=█████"
set "#6_2=█    "
set "#6_3=█████"
set "#6_4=█   █"
set "#6_5=█████"

set "#7_1=█████"
set "#7_2=    █"
set "#7_3=    █"
set "#7_4=    █"
set "#7_5=    █"

set "#8_1=█████"
set "#8_2=█   █"
set "#8_3=█████"
set "#8_4=█   █"
set "#8_5=█████"

set "#9_1=█████"
set "#9_2=█   █"
set "#9_3=█████"
set "#9_4=    █"
set "#9_5=█████"

set "#C_1= "
set "#C_2=█"
set "#C_3= "
set "#C_4=█"
set "#C_5= "

:clock_loop
	::Clear display [leaving a whitespace]...
for /l %%C in (1,1,5) do set "display%%C= "

	::Get current time [all spaces will be replaced to zero]...
	::Also, all colons will be replaced to "C" because colon has a function in variables...
set "curr_time=%time: =0%"
set "curr_time=%curr_time::=C%"

	::Process the numbers to display [we will now use the formats we SET above]...
for /l %%T in (0,1,7) do (
	::Check for each number and colons...
	for %%N in (0 1 2 3 4 5 6 7 8 9 C) do (
		if "!curr_time:~%%T,1!"=="%%N" (
			::Now, barbeque each formatted char in 5 rows...
			for /l %%D in (1,1,5) do set "display%%D=!display%%D!!#%%N_%%D! "
		)
	)
)

	::Refresh the clock...
cls
echo.
echo.[%display1%]
echo.[%display2%]
echo.[%display3%]
echo.[%display4%]
echo.[%display5%]
echo.
timeout /t 1 /nobreak >nul
goto :clock_loop
