@echo off
::24.bat
::
::Batch file implemetnation of the 24 Game where a player is given four random
::digits n, where 1 <= n <= 9, and needs to provide a simple arithmetic
::operation that does evaluate to 24.
::
::Note: [1]This implementation does not evaluate brackets
::      [2]This implementation does not keep remainders since batch language
::         has no support for floating point calculations
cls
echo The 24 Game
echo.
echo Given four digits, provide a simple arithmetic expression
echo that evaluates to 24 using +,-,*,/.
echo.
echo Enter 'SHOW' to show the digits or 'EXIT' to end the game.
echo.

set TRY=0

::Get four random digits
set /a "DIGIT_1=%RANDOM% %%9 + 1"
set /a "DIGIT_2=%RANDOM% %%9 + 1"
set /a "DIGIT_3=%RANDOM% %%9 + 1"
set /a "DIGIT_4=%RANDOM% %%9 + 1"

goto SHOW

::Main Program Loop
:MAIN
set /a TRY+=1
set "TMP_DIGIT_1=%DIGIT_1%"
set "TMP_DIGIT_2=%DIGIT_2%"
set "TMP_DIGIT_3=%DIGIT_3%"
set "TMP_DIGIT_4=%DIGIT_4%"

::Promt for an answer and trim answer string
set /p ANSWER="Try %TRY%: "
set "ANSWER=%ANSWER: =%"


if /i "%ANSWER%"=="SHOW" goto SHOW
if /i "%ANSWER%"=="EXIT" goto ABORT
if "%ANSWER:~6,1%"=="" goto ERROR_MISSING_CHARS:

::Determine if each digits has ben used once in the input equation
set DIGITS_USED=0
set COUNTER=0
:LOOP
call set CURR_DIGIT=%%ANSWER:~%COUNTER%,1%%
if %CURR_DIGIT%==%TMP_DIGIT_1% (set "TMP_DIGIT_1=" & set /a "DIGITS_USED+=1")
if %CURR_DIGIT%==%TMP_DIGIT_2% (set "TMP_DIGIT_2=" & set /a "DIGITS_USED+=2")
if %CURR_DIGIT%==%TMP_DIGIT_3% (set "TMP_DIGIT_3=" & set /a "DIGITS_USED+=4")
if %CURR_DIGIT%==%TMP_DIGIT_4% (set "TMP_DIGIT_4=" & set /a "DIGITS_USED+=8")
set /a "COUNTER+=2"
if not "%COUNTER%"=="8" goto LOOP
if not "%DIGITS_USED%"=="15" goto ERROR_INCORRECT_INPUT

::Calculate and evaluate result
set /a "RESULT=%ANSWER%"
if "%RESULT%"=="24" goto END

echo Invalid input [Bad result: Expected 24, Received %RESULT%]
goto MAIN

:ERROR_MISSING_CHARS
echo Invalid input [insufficient number of characters]
goto MAIN

:ERROR_INCORRECT_INPUT
echo Invalid input [incorrect digits]
goto MAIN

:SHOW
echo Given digits: %DIGIT_1% %DIGIT_2% %DIGIT_3% %DIGIT_4%
goto MAIN

:END
echo Correct input [Congratulations!]

:ABORT
echo.
