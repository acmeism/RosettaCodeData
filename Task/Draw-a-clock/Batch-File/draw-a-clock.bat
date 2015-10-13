::Draw a Clock Task from Rosetta Code Wiki
::Batch File Implementation
::
::Directly open the Batch File...
@echo off & mode 44,8
title Sample Batch Clock
setlocal enabledelayedexpansion

	::Set the characters...
set "#0_1=ÛÛÛÛÛ"
set "#0_2=Û   Û"
set "#0_3=Û   Û"
set "#0_4=Û   Û"
set "#0_5=ÛÛÛÛÛ"

set "#1_1=    Û"
set "#1_2=    Û"
set "#1_3=    Û"
set "#1_4=    Û"
set "#1_5=    Û"

set "#2_1=ÛÛÛÛÛ"
set "#2_2=    Û"
set "#2_3=ÛÛÛÛÛ"
set "#2_4=Û    "
set "#2_5=ÛÛÛÛÛ"

set "#3_1=ÛÛÛÛÛ"
set "#3_2=    Û"
set "#3_3=ÛÛÛÛÛ"
set "#3_4=    Û"
set "#3_5=ÛÛÛÛÛ"

set "#4_1=Û   Û"
set "#4_2=Û   Û"
set "#4_3=ÛÛÛÛÛ"
set "#4_4=    Û"
set "#4_5=    Û"

set "#5_1=ÛÛÛÛÛ"
set "#5_2=Û    "
set "#5_3=ÛÛÛÛÛ"
set "#5_4=    Û"
set "#5_5=ÛÛÛÛÛ"

set "#6_1=ÛÛÛÛÛ"
set "#6_2=Û    "
set "#6_3=ÛÛÛÛÛ"
set "#6_4=Û   Û"
set "#6_5=ÛÛÛÛÛ"

set "#7_1=ÛÛÛÛÛ"
set "#7_2=    Û"
set "#7_3=    Û"
set "#7_4=    Û"
set "#7_5=    Û"

set "#8_1=ÛÛÛÛÛ"
set "#8_2=Û   Û"
set "#8_3=ÛÛÛÛÛ"
set "#8_4=Û   Û"
set "#8_5=ÛÛÛÛÛ"

set "#9_1=ÛÛÛÛÛ"
set "#9_2=Û   Û"
set "#9_3=ÛÛÛÛÛ"
set "#9_4=    Û"
set "#9_5=ÛÛÛÛÛ"

set "#C_1= "
set "#C_2=Û"
set "#C_3= "
set "#C_4=Û"
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
