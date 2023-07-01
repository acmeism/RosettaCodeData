@echo off

::setting variables in defferent ways
set myInt1=5
set myString1=Rosetta Code
set "myInt2=5"
set "myString2=Rosetta Code"

::Arithmetic
set /a myInt1=%myInt1%+1
set /a myInt2+=1
set /a myInt3=myInt2+   5

set myInt
set myString
pause>nul
