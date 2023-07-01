:: 2048 Game Task from RosettaCode
:: Batch File Implementation v2.0.1

@echo off
setlocal enabledelayedexpansion

rem initialization
:begin_game
set "size=4"   %== board size ==%
set "score=0"   %== current score ==%
set "won=0"   %== boolean for winning ==%
set "target=2048"   %== as the game title says ==%
for /l %%R in (1,1,%size%) do for /l %%C in (1,1,%size%) do set "X_%%R_%%C=0"

rem add two numbers in the board
call :addtile
call :addtile

rem main game loop
:main_loop
call :display
echo(
echo(Keys: WASD (Slide Movement), N (New game), P (Exit)

rem get keypress trick
set "key="
for /f "delims=" %%? in ('xcopy /w "%~f0" "%~f0" 2^>nul') do if not defined key set "key=%%?"
set "key=%key:~-1%"

set "changed=0"   %== boolean for changed board ==%
set "valid_key=0"   %== boolean for pressing WASD ==%
rem process keypress
if /i "!key!" equ "W" (set "valid_key=1" & call :slide "C" "1,1,%size%" "X")
if /i "!key!" equ "A" (set "valid_key=1" & call :slide "R" "1,1,%size%" "X")
if /i "!key!" equ "S" (set "valid_key=1" & call :slide "C" "%size%,-1,1" "X")
if /i "!key!" equ "D" (set "valid_key=1" & call :slide "R" "%size%,-1,1" "X")
if /i "!key!" equ "N" goto begin_game
if /i "!key!" equ "P" exit /b 0
if "%valid_key%" equ "0" goto main_loop

rem check if the board changed
if %changed% neq 0 call :addtile

rem check for win condition
if %won% equ 1 (
    set "msg=Nice one... You WON^!^!"
    goto gameover
)

rem check for lose condition
if %blank_count% equ 0 (
    for /l %%R in (1,1,%size%) do for /l %%C in (1,1,%size%) do set "LX_%%R_%%C=!X_%%R_%%C!"
    set "save_changed=%changed%" & set "changed=0"   %== save actual changed for test ==%
    call :slide "C" "1,1,%size%" "LX"
    call :slide "R" "1,1,%size%" "LX"
    if !changed! equ 0 (
        set "msg=No moves are possible... Game Over :("
        goto gameover
    ) else set "changed=!save_changed!"
)
goto main_loop

rem add number to a random blank tile
:addtile
set "blank_count=0"   %== blank tile counter ==%
set "new_tile="   %== clearing ==%
rem create pseudo-array blank_tiles
for /l %%R in (1,1,%size%) do (
    for /l %%C in (1,1,%size%) do (
        if !X_%%R_%%C! equ 0 (
            set "blank_tiles[!blank_count!]=X_%%R_%%C"
            set /a "blank_count+=1"
        )
    )
)
if %blank_count% equ 0 goto :EOF
set /a "pick_tile=%random%%%%blank_count%"
set "new_tile=!blank_tiles[%pick_tile%]!"
set /a "rnd_newnum=%random%%%10"
rem 10% chance new number is 4, 90% chance it's 2
if %rnd_newnum% equ 5 (set "%new_tile%=4") else (set "%new_tile%=2")
set /a "blank_count-=1"   %== to be used for checking lose condition ==%
goto :EOF

rem display the board
:display
cls
echo(2048 Game in Batch
echo(
set "wall=+"
for /l %%C in (1,1,%size%) do set "wall=!wall!----+"
for /l %%R in (1,1,%size%) do (
    set "disp_row=|"
    for /l %%C in (1,1,%size%) do (
        if "!new_tile!" equ "X_%%R_%%C" (set "DX_%%R_%%C=  +!X_%%R_%%C!") else (
            set "DX_%%R_%%C=!X_%%R_%%C!"
            if !X_%%R_%%C! lss 1000 set "DX_%%R_%%C= !DX_%%R_%%C!"
            if !X_%%R_%%C! lss 100 set "DX_%%R_%%C= !DX_%%R_%%C!"
            if !X_%%R_%%C! lss 10 set "DX_%%R_%%C= !DX_%%R_%%C!"
            if !X_%%R_%%C! equ 0 set "DX_%%R_%%C=    "
        )
        set "disp_row=!disp_row!!DX_%%R_%%C!|"
    )
    echo(%wall%
    echo(!disp_row!
)
echo(%wall%
echo(
echo(Score: %score%
goto :EOF

rem the main slider of numbers in tiles
:slide
rem %%A and %%B are used here because sliding direction is variable
for /l %%A in (1,1,%size%) do (
    rem first slide: removing blank tiles in the middle
    set "slide_1="
    set "last_blank=0"   %== boolean if last tile is blank ==%
    for /l %%B in (%~2) do (
        if "%~1" equ "R" (set "curr_tilenum=!%~3_%%A_%%B!"
        ) else if "%~1" equ "C" (set "curr_tilenum=!%~3_%%B_%%A!")
        if !curr_tilenum! equ 0 (set "last_blank=1") else (
            set "slide_1=!slide_1! !curr_tilenum!"
            if !last_blank! equ 1 set "changed=1"
            set "last_blank=0"
        )
    )
    rem second slide: addition of numbered tiles
    rem slide_2 would be pseudo-array
    set "slide_2_count=0"
    set "skip=1"   %== boolean for skipping after previous summing ==%
    if "!slide_1!" neq "" for %%S in (!slide_1! 0) do (
        if !skip! equ 1 (
            set "prev_tilenum=%%S" & set "skip=0"
        ) else if !skip! equ 0 (
            if %%S equ !prev_tilenum! (
                set /a "sum=%%S+!prev_tilenum!"
                if "%~3" equ "X" set /a "score+=sum"
                set "changed=1" & set "skip=1"
                rem check for winning condition!
                if !sum! equ !target! set "won=1"
            ) else (
                set "sum=!prev_tilenum!"
                set "prev_tilenum=%%S"
            )
            set "slide_2[!slide_2_count!]=!sum!"
            set /a "slide_2_count+=1"
        )
    )
    rem new values of tiles
    set "slide_2_run=0"   %== running counter for slide_2 ==%
    for /l %%B in (%~2) do (
        if "%~1" equ "R" (set "curr_tile=%~3_%%A_%%B"
        ) else if "%~1" equ "C" (set "curr_tile=%~3_%%B_%%A")
        for %%? in ("!slide_2_run!") do (
            if %%~? lss !slide_2_count! (set "!curr_tile!=!slide_2[%%~?]!"
            ) else (set "!curr_tile!=0")
        )
        set /a "slide_2_run+=1"
    )
)
goto :EOF

rem game over xD
:gameover
call :display
echo(
echo(!msg!
echo(
echo(Press any key to exit . . .
pause>nul
exit /b 0
