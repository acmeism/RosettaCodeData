@echo off
rem Magic squares of odd order
setlocal EnableDelayedExpansion
set n=9
echo The square order is: %n%
for /l %%i in (1,1,%n%) do (
    set w=
    for /l %%j in (1,1,%n%) do (
        set /a v1=%%i*2-%%j+n-1
        set /a v1=v1%%n*n
        set /a v2=%%i*2+%%j+n-2
        set /a v2=v2%%n
        set /a v=v1+v2+1
		set v=     !v!
	    set w=!w!!v:~-5!)
	echo !w!)
set /a w=n*(n*n+1)/2
echo The magic number is: %w%
pause
