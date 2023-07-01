@echo off
setlocal enableDelayedExpansion

set /p "name=Enter a variable name: "
set /p "value=Enter a value: "

::Create the variable and set its value
set "%name%=%value%"

::Display the value without delayed expansion
call echo %name%=%%%name%%%

::Display the value using delayed expansion
echo %name%=!%name%!
