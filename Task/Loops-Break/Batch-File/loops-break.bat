@echo off
:loop
  set /a N=%RANDOM% %% 20
  echo %N%
  if %N%==10 exit /b
goto loop
