@echo off

::Output to console
echo Goodbye, World!

::Output to message box
msg * "Goodbye, World!"

::Output to file and open it
echo Goodbye, World!>temp.txt
start temp.txt

pause>nul
