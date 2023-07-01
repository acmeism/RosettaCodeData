:: This line is only required to increase the readability of the output by hiding the lines of code being executed
@echo off

:: Everything between the lines keeps repeating until the answer is found
:: The code works by, starting at 1, checking to see if the last 6 digits of the current number squared is equal to 269696
::----------------------------------------------------------------------------------
:loop
:: Increment the current number being tested by 1
set /a number+=1

:: Square the current number
set /a numbersquared=%number%*%number%

:: Check if the last 6 digits of the current number squared is equal to 269696, and if so, stop looping and go to the end
if %numbersquared:~-6%==269696 goto end

goto loop
::----------------------------------------------------------------------------------

:end
echo %number% * %number% = %numbersquared%
pause>nul
