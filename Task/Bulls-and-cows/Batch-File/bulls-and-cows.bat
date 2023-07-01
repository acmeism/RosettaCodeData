:: Bulls and Cows Task from Rosetta Code
:: Batch File Implementation

@echo off
setlocal enabledelayedexpansion

:: initialization
:begin
set "list_chars=123456789"
set "list_length=9"
set "code="
set "code_length=4"   %== this should be less than 10 ==%
set "tries=0"   %== number of tries ==%

:: generate the code to be guessed by player
set "chars_left=%list_chars%"
for /l %%c in (1, 1, %code_length%) do (
    set /a "rnd=!random! %% (%list_length% + 1 - %%c)"
    for %%? in (!rnd!) do set "pick_char=!chars_left:~%%?,1!"
    set "code=!code!!pick_char!"
    for %%? in (!pick_char!) do set "chars_left=!chars_left:%%?=!"
)

:: get the min and max allowable guess for input validation
set "min=!list_chars:~0,%code_length%!"
set "max="
for /l %%c in (1, 1, %code_length%) do set "max=!max!!list_chars:~-%%c,1!"

:: display game
:display
cls
echo(
echo(Bulls and Cows Game
echo(Batch File Implementation
echo(
echo(Gameplay:
echo(
echo(I have generated a %code_length%-digit code from digits 1-9 without duplication.
echo(Your objective is to guess it. If your guess is equal to my code,
echo(then you WIN. If not, I will score your guess:
echo(
echo(** A score of one BULL is accumulated for each digit in your guess
echo(that equals the corresponding digit in my code.
echo(
echo(** A score of one COW is accumulated for each digit in your guess
echo(that also appears in my code, but in the WRONG position.
echo(
echo(Now, start guessing^^!

:: input guess
:guess
echo(
set "guess="   %== clear input ==%
set /p "guess=Your Guess: "

:: validate input
if "!guess!" gtr "%max%" goto invalid
if "!guess!" lss "%min%" goto invalid
set /a "last_idx=%code_length% - 1"
for /l %%i in (0, 1, %last_idx%) do (
    set /a "next_idx=%%i + 1"
    for /l %%j in (!next_idx!, 1, %last_idx%) do (
        if "!guess:~%%i,1!" equ "!guess:~%%j,1!" goto invalid
    )
)
goto score

:: display that input is invalid
:invalid
echo(Please input a valid guess.
goto guess

:: scoring section
:score
set /a "tries+=1"
if "%guess%" equ "%code%" goto win
set "cow=0"
set "bull=0"
for /l %%i in (0, 1, %last_idx%) do (
    for /l %%j in (0, 1, %last_idx%) do (
        if "!guess:~%%i,1!" equ "!code:~%%j,1!" (
            if "%%i" equ "%%j" (
                set /a "bull+=1"
            ) else (
                set /a "cow+=1"
            )
        )
    )
)
:: display score and go back to user input
echo(BULLS = %bull%; COWS = %cow%.
goto guess

:: player wins!
:win
echo(
echo(After %tries% tries, YOU CRACKED IT^^! My code is %code%.
echo(
set /p "opt=Play again? "
if /i "!opt!" equ "y" goto begin
exit /b 0
