@echo off
setlocal enableextensions enabledelayedexpansion
for /L %%i in (1,1,100) do (
  set /a "fizz=%%i%%3, buzz=%%i%%5, fizzbuzz=fizz+buzz" %= or fizzbuzz=%%i%%15 =%
  if "!fizzbuzz!"=="0" (echo FizzBuzz
  ) else (if "!fizz!"=="0" (echo Fizz
  ) else (if "!buzz!"=="0" (echo Buzz) else (echo %%i)))
)
