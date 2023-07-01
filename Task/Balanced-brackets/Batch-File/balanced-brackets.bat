:: Balanced Brackets Task from Rosetta Code
:: Batch File Implementation

@echo off
setlocal enabledelayedexpansion

set "num_pairs=10"
set "num_strings=10"

:: the main thing
for /l %%s in (1, 1, %num_strings%) do (
    call :generate
    call :check
)
echo(
pause
exit /b 0

:: generate strings of brackets
:generate
set "string="
rem put %num_pairs% number of "[" in string
for /l %%c in (1, 1, %num_pairs%) do set "string=!string!["
rem put %num_pairs% number of "]" in random spots of string
set "ctr=%num_pairs%"
for /l %%c in (1, 1, %num_pairs%) do (
    set /a "rnd=!random! %% (!ctr! + 1)"
    for %%x in (!rnd!) do (
        set "left=!string:~0,%%x!"
        set "right=!string:~%%x!"
    )
    set "string=!left!]!right!"
    set /a "ctr+=1"
)
goto :EOF

:: check for balance
:check
set "new=%string%"
:check_loop
if "%new%" equ "" (
    echo(
    echo(%string% is Balanced.
    goto :EOF
) else if "%old%" equ "%new%" (   %== unchangeable already? ==%
    echo(
    echo(%string% is NOT Balanced.
    goto :EOF
)
rem apply rewrite rule "[]" -> null
set "old=%new%"
set "new=%old:[]=%"
goto check_loop
