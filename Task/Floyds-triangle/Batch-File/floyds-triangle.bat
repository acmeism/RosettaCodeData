:: Floyd's triangle Task from Rosetta Code
:: Batch File Implementation

@echo off
rem main thing
setlocal enabledelayedexpansion
call :floydtriangle 5
echo(
call :floydtriangle 14
exit /b 0

:floydtriangle
set "fila=%1"
for /l %%c in (1,1,%fila%) do (
    set /a "lastRowNum=%%c+fila*(fila-1)/2"
    rem count number of digits of whole number trick
    rem source: https://stackoverflow.com/a/45472269
    set /a "Log=1!lastRowNum:~1!-!lastRowNum:~1!-0"
    set /a "numColum[%%c]=!Log:0=+1!"
)
echo(Output for %fila%
set "thisNum=1"
for /l %%r in (1,1,%fila%) do (
    set "printLine="
    for /l %%c in (1,1,%%r) do (
        rem count number of digits of whole number trick
        set /a "Log=1!thisNum:~1!-!thisNum:~1!-0"
        set /a "thisNumColum=!Log:0=+1!"
        rem handle spacing
        set "space= "
        set /a "extra=!numColum[%%c]!-!thisNumColum!"
        for /l %%s in (1,1,!extra!) do set "space=!space! "
        rem append current number to printLine
        set "printLine=!printLine!!space!!thisNum!"
        set /a "thisNum=!thisNum!+1"
    )
    echo(!printLine!
)
goto :EOF
