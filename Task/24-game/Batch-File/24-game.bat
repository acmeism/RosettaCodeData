@set @dummy=0 /*

::24.bat
::
::Batch file implemetnation of the 24 Game where a player is given four random
::digits n, where 1 <= n <= 9, and needs to provide a simple arithmetic
::operation that does evaluate to 24.
::
::Please open the Batch File Directly to play...

@echo off
setlocal enabledelayedexpansion
title The 24 Game Batch File
cls
echo.
echo The 24 Game
echo.
echo Given four digits, provide a simple arithmetic expression
echo that evaluates to 24 using +,-,*,/.
echo.
echo Reminders (Please read):
echo.
echo     1. Type 'new' (NO quotes) - Fresh digits
echo     2. Type 'show' (NO quotes) - Show digits
echo     3. Type 'exit' (NO quotes) - Quit game
echo     4. Combining two digits as one number is NOT allowed.
echo     5. Use each digit only ONCE in expressions.
echo     6. Use ONLY the Parentheses as the groupting symbols.
echo     7. Do not make any digit Negative.
echo.
echo Why do someone wants to not follow the reminders? To trick me, right? ;)
echo.
pause

:NEW
set TRY=0

::Get four random digits
set /a "DIGIT_1=%RANDOM%%%9+1"
set /a "DIGIT_2=%RANDOM%%%9+1"
set /a "DIGIT_3=%RANDOM%%%9+1"
set /a "DIGIT_4=%RANDOM%%%9+1"

cls
echo.
echo The 24 Game
echo.
goto SHOW

::Main Program Loop
:MAIN
set /a TRY+=1
set ANSWER=
set "TMP_DIGIT_1=%DIGIT_1%"
set "TMP_DIGIT_2=%DIGIT_2%"
set "TMP_DIGIT_3=%DIGIT_3%"
set "TMP_DIGIT_4=%DIGIT_4%"

::Prompt for an answer
echo.
set /p ANSWER="Try %TRY%: "

::Determine if the player inputs a "good" try (input validation...)
if /i "!ANSWER!"=="NEW" goto NEW
if /i "!ANSWER!"=="SHOW" goto SHOW
if /i "!ANSWER!"=="EXIT" goto ABORT

set ANSWER=!ANSWER: =!
set DIGITS_USED=0&set COUNTER=0

:LOOP
set CURR_DIGIT=!ANSWER:~%COUNTER%,1!
if "!CURR_DIGIT!"=="%TMP_DIGIT_1%" (set "TMP_DIGIT_1=X"&goto NEXTCHARSCAN1)
if "!CURR_DIGIT!"=="%TMP_DIGIT_2%" (set "TMP_DIGIT_2=X"&goto NEXTCHARSCAN1)
if "!CURR_DIGIT!"=="%TMP_DIGIT_3%" (set "TMP_DIGIT_3=X"&goto NEXTCHARSCAN1)
if "!CURR_DIGIT!"=="%TMP_DIGIT_4%" (set "TMP_DIGIT_4=X"&goto NEXTCHARSCAN1)
if "!CURR_DIGIT!"=="" goto ALMOST
if "!CURR_DIGIT!"==")" goto SCANMORE
if "!CURR_DIGIT!"=="(" goto SCANMORE
if "!CURR_DIGIT!"=="+" goto NEXTCHARSCAN2
if "!CURR_DIGIT!"=="-" goto DONTALLOWNEGATIVES
if "!CURR_DIGIT!"=="*" goto NEXTCHARSCAN2
if "!CURR_DIGIT!"=="/" goto NEXTCHARSCAN2
goto ERROR_ICHAR_FOUND

:NEXTCHARSCAN1
set /a NEXT=%COUNTER%+1
set NEXT_CHAR=!ANSWER:~%NEXT%,1!
for /l %%w in (1,1,9) do (
if "!NEXT_CHAR!"=="%%w" goto ERROR_POSITION
)
goto :SCANMORE
:DONTALLOWNEGATIVES
set /a NEXT=%COUNTER%-1
if "%NEXT%"=="-1" goto ERROR_NEGA
set NEXT_CHAR=!ANSWER:~%NEXT%,1!
for /l %%z in (1,1,9) do (
if "!NEXT_CHAR!"=="%%z" goto NEXTCHARSCAN2
)
if "!NEXT_CHAR!"=="(" goto ERROR_NEGA
if "!NEXT_CHAR!"==")" goto NEXTCHARSCAN2
goto ERROR_NEGA
:NEXTCHARSCAN2
set /a NEXT=%COUNTER%+1
set NEXT_CHAR=!ANSWER:~%NEXT%,1!
for %%y in (+,-,/) do (
if "!NEXT_CHAR!"=="%%y" goto ERROR_TRICK
)
:SCANMORE
set /a "COUNTER+=1"&goto LOOP

:ALMOST
if not "%TMP_DIGIT_1%%TMP_DIGIT_2%%TMP_DIGIT_3%%TMP_DIGIT_4%"=="XXXX" goto ERROR_CHARS
::(SIGH) Input passed... Now, calculate and evaluate result
set "RESULT="
for /f "usebackq delims=" %%x in (`cscript //nologo //e:jscript "%~f0" "%ANSWER%" 2^>nul`) do set RESULT=%%x
::Wait... Input is STILL erroneous???
if "%RESULT%"=="" goto ERROR_SYNTAX
::YES!!! Correct Expression???
if "%RESULT%"=="24" goto END

::The Outputs

echo Wrong Answer  [%RESULT% is not equal to 24.]&goto MAIN
:ERROR_CHARS
echo Invalid input [Please use all the digits above ONCE.]&goto MAIN
:ERROR_ICHAR_FOUND
echo Invalid input [An invalid character is found... C'mon...]&goto MAIN
:ERROR_SYNTAX
echo Invalid input [Syntax Error... Please answer seriously... I'm begging you...]&goto MAIN
:ERROR_POSITION
echo Invalid input [Sorry, digit concatenation is not allowed.]&goto MAIN
:ERROR_TRICK
echo Invalid input [Are you Playing the Game Seriously?]&goto MAIN
:ERROR_NEGA
echo Invalid input [Do not Make any Digit Negative.]&goto MAIN
:SHOW
echo Given digits: %DIGIT_1% %DIGIT_2% %DIGIT_3% %DIGIT_4%&goto MAIN
:END
echo Correct Input [Congratulations^^!]
echo.
echo Press any char key for a new game, or close this window to exit...
pause>nul
goto NEW
:ABORT
echo.
exit
::*/

WScript.echo(eval(WScript.arguments(0)));
