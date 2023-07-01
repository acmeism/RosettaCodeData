::Long Multiplication Task from Rosetta Code
::Batch File Implementation

@echo off
call :longmul 18446744073709551616 18446744073709551616 answer
echo(%answer%
exit /b 0

rem The Hellish Procedure
rem Syntax: call :longmul <n1> <n2> <variable to store product>
:longmul
    setlocal enabledelayedexpansion

    rem Define variables
    set "num1=%1"
    set "num2=%2"
    set "limit1=-1"
    set "limit2=-1"
    set "length=0"
    set "prod="

    rem Reverse the digits of each factor
    for %%A in (1,2) do (
        for /l %%B in (0,1,9) do set "num%%A=!num%%A:%%B=%%B !"
        for %%C in (!num%%A!) do ( set /a limit%%A+=1 & set "rev%%A=%%C!rev%%A!" )
    )

    rem Do the multiplication
    for /l %%A in (0,1,%limit1%) do (
        for /l %%B in (0,1,%limit2%) do (
            set /a iter=%%A+%%B
            set /a iternext=iter+1
            set /a iternext2=iter+2

            set /a prev=digit!iter!
            set /a digit!iter!=!rev1:~%%A,1!*!rev2:~%%B,1!

            rem The next line updates the length of "digits"
            if !iternext! gtr !length! set length=!iternext!
            if !iter! lss !length! set /a digit!iter!+=prev

            set /a currdigit=digit!iter!
            if !currDigit! gtr 9 (
                set /a prev=digit!iternext!
                set /a digit!iternext!=currdigit/10
                set /a digit!iter!=currdigit%%10

                rem The next line updates the length of "digits"
                if !iternext2! gtr !length! set length=!iternext2!
                if !iternext! lss !length! set /a digit!iternext!+=prev
            )
        )
    )

    rem Finalize product reversing the digits
    for /l %%F in (0,1,%length%) do set "prod=!digit%%F!!prod!"
    endlocal & set "%3=%prod%"
goto :eof
