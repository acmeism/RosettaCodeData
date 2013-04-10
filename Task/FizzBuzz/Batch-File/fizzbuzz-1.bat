@echo off
for /L %%i in (1,1,100) do call :tester %%i
goto :eof

:tester
set /a test = %1 %% 15
if %test% NEQ 0 goto :NotFizzBuzz
echo FizzBuzz
goto :eof

:NotFizzBuzz
set /a test = %1 %% 5
if %test% NEQ 0 goto :NotBuzz
echo Buzz
goto :eof

:NotBuzz
set /a test = %1 %% 3
if %test% NEQ 0 goto :NotFizz
echo Fizz
goto :eof

:NotFizz
echo %1
