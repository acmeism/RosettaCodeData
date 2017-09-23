@echo off
setlocal enabledelayedexpansion

:: ":main" is where all the non-logic-gate stuff happens
:main
:: User input two 4-digit binary numbers
:: There is no error checking for these numbers, however if the first 4 digits of both inputs are in binary...
:: The program will use them. All non-binary numbers are treated as 0s, but having less than 4 digits will crash it
set /p "input1=First 4-Bit Binary Number: "
set /p "input2=Second 4-Bit Binary Number: "

:: Put the first 4 digits of the binary numbers and separate them into "A[]" for input A and "B[]" for input B
for /l %%i in (0,1,3) do (
  set A%%i=!input1:~%%i,1!
  set B%%i=!input2:~%%i,1!
)

:: Run the 4-bit Adder with "A[]" and "B[]" as parameters. The program supports a 9th parameter for a Carry input
call:_4bitAdder %A3% %A2% %A1% %A0% %B3% %B2% %B1% %B0% 0

:: Display the answer and exit
echo %input1% + %input2% = %outputC%%outputS4%%outputS3%%outputS2%%outputS1%
pause>nul
exit /b

:: Function for the 4-bit Adder following the logic given
:_4bitAdder
set inputA1=%1
set inputA2=%2
set inputA3=%3
set inputA4=%4

set inputB1=%5
set inputB2=%6
set inputB3=%7
set inputB4=%8

set inputC=%9

call:_FullAdder %inputA1% %inputB1% %inputC%
set outputS1=%outputS%
set inputC=%outputC%

call:_FullAdder %inputA2% %inputB2% %inputC%
set outputS2=%outputS%
set inputC=%outputC%

call:_FullAdder %inputA3% %inputB3% %inputC%
set outputS3=%outputS%
set inputC=%outputC%

call:_FullAdder %inputA4% %inputB4% %inputC%
set outputS4=%outputS%
set inputC=%outputC%

:: In order return more than one number (of which is usually done via 'exit /b') we declare them while ending the local environment
endlocal && set "outputS1=%outputS1%" && set "outputS2=%outputS2%" && set "outputS3=%outputS3%" && set "outputS4=%outputS4%" && set "outputC=%inputC%"
exit /b

:: Function for the 1-bit Adder following the logic given
:_FullAdder
setlocal
set inputA=%1
set inputB=%2
set inputC1=%3

call:_halfAdder %inputA% %inputB%
set inputA1=%outputS%
set inputA2=%inputA1%
set inputC2=%outputC%

call:_HalfAdder %inputA1% %inputC1%
set outputS=%outputS%
set inputC1=%outputC%

call:_Or %inputC1% %inputC2%
set outputC=%errorlevel%

endlocal && set "outputS=%outputS%" && set "outputC=%outputC%"
exit /b

:: Function for the half-bit adder following the logic given
:_halfAdder
setlocal
set inputA1=%1
set inputA2=%inputA1%
set inputB1=%2
set inputB2=%inputB1%

call:_XOr %inputA1% %inputB2%
set outputS=%errorlevel%

call:_And %inputA2% %inputB2%
set outputC=%errorlevel%

endlocal && set "outputS=%outputS%" && set "outputC=%outputC%"
exit /b

:: Function for the XOR-gate following the logic given
:_XOr
setlocal
set inputA1=%1
set inputB1=%2

call:_Not %inputA1%
set inputA2=%errorlevel%

call:_Not %inputB1%
set inputB2=%errorlevel%

call:_And %inputA1% %inputB2%
set inputA=%errorlevel%

call:_And %inputA2% %inputB1%
set inputB=%errorlevel%

call:_Or %inputA% %inputB%
set outputA=%errorlevel%

:: As there is only one output, we can use 'exit /b {errorlevel}' to return a specified errorlevel
exit /b %outputA%

:: The basic 3 logic gates that every other funtion is composed of
:_Not
setlocal
if %1==0 exit /b 1
exit /b 0
:_Or
setlocal
if %1==1 exit /b 1
if %2==1 exit /b 1
exit /b 0
:_And
setlocal
if %1==1 if %2==1 exit /b 1
exit /b 0
