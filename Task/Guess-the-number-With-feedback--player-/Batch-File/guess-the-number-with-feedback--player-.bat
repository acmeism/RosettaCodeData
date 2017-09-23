@echo off

:: Player is prompted to give a number between %min% and %max%. If the input is out of those limits they are prompted to choose again
:choose
set min=0
set max=100

set /p "number=Choose a number [%min%-%max%]: "
if %number% gtr %max% goto choose
if %number% lss %min% goto choose
set attempts=0

:: Loops the guessing process until completed
:comp
set /a attempts+=1
set /a guess=(%max%-%min%)/2+%min%
choice /c "HLE" /n /m "Guess: %guess% - [H]igher, [L]ower or [E]qual"
if errorlevel 3 goto end
if errorlevel 2 (
  set max=%guess%
  goto comp
)
if errorlevel 1 (
  set min=%guess%
  goto comp
)

:end
echo Guesses: %attempts%
pause>nul
