@echo off

::call a function with no arguments
call :myFunction

::call a function with arguments
call :myFunction arg1 "arg 2"

::initiate a "function".
:myFunction
echo arg1 - %1
echo arg2 - %~2
goto :eof
