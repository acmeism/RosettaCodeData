@echo off
set n=1

:loop
  call :tester %n%
  set /a n += 1
  if %n% LSS 101 goto loop
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
