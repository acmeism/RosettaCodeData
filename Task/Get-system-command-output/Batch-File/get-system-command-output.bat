@echo off
setlocal enabledelayedexpansion

:: Without storing the output of the command, it can be viewed by inputting the command
dir


:: Storing the output of 'dir' as "line[]" containing the respective lines of output (starting at line[1])
:: Note: This method removes any empty lines from the output
set tempcount=0
for /f "tokens=*" %%i in ('dir') do (
  set /a tempcount+=1
  set "line!tempcount!=%%i"
)
:: The array would be viewed like this
for /l %%i in (1,1,%tempcount%) do echo !line%%i!


:: Storing the output of 'dir' in a file, then outputting the contents of the file to the screen
:: NOTE: rewrites any file named "out.temp" in the current directory
dir>out.temp
type out.temp
del out.temp

pause>nul
