::NOTE #1: This implementation might crash, or might not work properly if
::you put some of the CMD special characters (ex. %,!, etc) inside the strings.
::
::NOTE #2: The comparisons here are case-SENSITIVE.
::NOTE #3: Spaces in strings are considered.

@echo off
setlocal enabledelayedexpansion

::The main things...
set "str1=qwertyuiop"
set "str2=qwerty"
call :str2_lngth
call :matchbegin

set "str1=qweiuoiocghiioyiocxiisfguiioiuygvd"
set "str2=io"
call :str2_lngth
call :matchcontain

set "str1=blablabla"
set "str2=bbla"
call :str2_lngth
call :matchend

echo.
pause
exit /b 0
::/The main things.

::The functions...
:matchbegin
echo.
if "!str1:~0,%length%!"=="!str2!" (
	echo "%str1%" begins with "%str2%".
) else (
	echo "%str1%" does not begin with "%str2%".
)
goto :EOF

:matchcontain
echo.
set curr=0&set exist=0
:scanchrloop
if "!str1:~%curr%,%length%!"=="" (
	if !exist!==0 echo "%str1%" does not contain "%str2%".
	goto :EOF
)
if "!str1:~%curr%,%length%!"=="!str2!" (
	echo "%str1%" contains "%str2%". ^(in Position %curr%^)
	set exist=1
)
set /a curr+=1&goto scanchrloop
	
:matchend
echo.
if "!str1:~-%length%!"=="!str2!" (
	echo "%str1%" ends with "%str2%".
) else (
	echo "%str1%" does not end with "%str2%".
)
goto :EOF

:str2_lngth
set length=0
:loop
if "!str2:~%length%,1!"=="" goto :EOF
set /a length+=1
goto loop
::/The functions.
