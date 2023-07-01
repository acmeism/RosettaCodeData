@echo off

:_main
setlocal enabledelayedexpansion

:: This block of code is putting a list delimitered by spaces into an pseudo-array
:: In practice, this could be its own function _createArray however for the demonstration, it is built in
set colour_list=red yellow blue orange green
set array_entry=0
for %%i in (%colour_list%) do (
  set /a array_entry+=1
  set colours[!array_entry!]=%%i
)

call:_arrayLength colours
echo _arrayLength returned %errorlevel%
pause>nul
exit /b

:: _arrayLength returns the length of the array parsed to it in the errorcode
:_arrayLength
setlocal enabledelayedexpansion

:loop
set /a arrayentry=%arraylength%+1
if "!%1[%arrayentry%]!"=="" exit /b %arraylength%
set /a arraylength+=1
goto loop
