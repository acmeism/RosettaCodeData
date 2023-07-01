@echo off & setlocal enabledelayedexpansion
for /l %%i in (1,1,100) do (
  set /a m5=%%i %% 5
  set /a m3=%%i %% 3
  set s=
  if !m5! equ 0 set s=!s!Fizz
  if !m3! equ 0 set s=!s!Buzz
  if "!s!"=="" set s=%%i
  echo !s!
)
