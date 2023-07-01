:: Matrix Digital Rain Task from RosettaCode
:: Batch File Implementation

@echo off
setlocal enabledelayedexpansion

rem escape character (for Windows 10 VT100 escape sequences)
rem info: https://docs.microsoft.com/en-us/windows/console/console-virtual-terminal-sequences
for /f %%e in ('echo prompt $e^| cmd') do @set "esc=%%e"

rem set window size
set "col=120"   %== please don't make this too large ==%
set "row=30"   %== please don't make this too large ==%
mode con cols=%col% lines=%row%

rem set up the variables for display
set "rain_length=12"
for /l %%y in (1,1,%col%) do set "disp_col[%%y]= "   %== what to display ==%
for /l %%y in (1,1,%col%) do set "ctr_col[%%y]=0"   %== counter for rain length ==%

rem hide the cursor, and clear the screen
<nul set /p "=%esc%[?25l"
cls

:matrix_loop
for /l %%y in (1,1,%col%) do (
    if !ctr_col[%%y]! equ 0 (
        set "disp_col[%%y]= "
    ) else (
        set /a "rnd_digit=!random! %% 10"
        if !ctr_col[%%y]! equ 1 (
            set "disp_col[%%y]=%esc%[97m!rnd_digit!%esc%[32m"
        ) else if !ctr_col[%%y]! equ 2 (
            set "disp_col[%%y]=%esc%[92m!rnd_digit!%esc%[32m"
        ) else (
            set "disp_col[%%y]=!rnd_digit!"
        )
        set /a "ctr_col[%%y]=(!ctr_col[%%y]! + 1) %% (%rain_length% + 1)"
    )
    rem drop rain randomly
    set /a "rnd_drop=!random! %% 20"
    if !rnd_drop! equ 0 set "ctr_col[%%y]=1"
)
set "disp_line=%esc%[32m"
for /l %%y in (1,1,%col%) do set "disp_line=!disp_line!!disp_col[%%y]!"
<nul set /p "=%esc%[1T%esc%[1;1H"   %== scroll down and set cursor position to home ==%
echo(%disp_line%
goto matrix_loop
