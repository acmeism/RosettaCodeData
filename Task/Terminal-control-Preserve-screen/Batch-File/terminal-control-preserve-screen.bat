@echo off
setlocal enableextensions
for /F %%a in ('prompt $E ^& for %%a in ^(1^) do rem') do set "\033=%%a"
echo %\033%[?1049h%\033%[H
echo Alternate buffer!
for %%i in (5 4 3 2 1) do (
  echo Going back in: %%i
  timeout /t 1 >nul
)
echo %\033%[?1049l
