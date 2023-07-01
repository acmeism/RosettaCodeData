@echo off
rem input range
set /p "range=> "

rem input data (no error-checking)
set "data_ctr=0"
:input_loop
set "data="
set /p "data=> "
if "%data%" equ "" goto count
rem parsing data into 1-based pseudo-array
set /a "data_ctr+=1"
for /f "tokens=1-2 delims= " %%D in ("%data%") do (
   set "facto%data_ctr%=%%D"
   set "print%data_ctr%=%%E"
)
goto input_loop

rem perform fizzbuzz now
:count
setlocal enabledelayedexpansion
for /l %%C in (1,1,%range%) do (
   set "out="
   for /l %%X in (1,1,%data_ctr%) do (
      set /a "mod=%%C %% facto%%X"
      if !mod! equ 0 set "out=!out!!print%%X!"
   )
   if not defined out (echo %%C) else (echo !out!)
)
pause
exit /b 0
