@echo off
setlocal enabledelayedexpansion
	%=== The Main Thing... ===%
set "inp=Rosetta Code phrase reversal"
call :reverse_string "!inp!" rev1
call :reverse_order "!inp!" rev2
call :reverse_words "!inp!" rev3
cls
echo.Original:       !inp!
echo.Reversed:       !rev1!
echo.Reversed Order: !rev2!
echo.Reversed Words: !rev3!
pause>nul
exit /b 0
	%=== /The Main Thing... ===%

	%=== Reverse the Order Function ===%
:reverse_order
set var1=%2
set %var1%=&set word=&set str1=%1
:process1
for /f "tokens=1,*" %%A in (%str1%) do (set str1=%%B&set word=%%A)
set %var1%=!word! !%var1%!&set str1="!str1!"
if not !str1!=="" goto process1
goto :EOF
	%=== /Reverse the Order Function ===%

	%=== Reverse the Whole String Function ===%
:reverse_string
set var2=%2
set %var2%=&set cnt=0&set str2=%~1
:process2
set char=!str2:~%cnt%,1!&set %var2%=!char!!%var2%!
if not "!char!"=="" set /a cnt+=1&goto process2
goto :EOF
	%=== /Reverse the Whole String Function ===%

	%=== Reverse each Words Function ===%
:reverse_words
set var3=%2
set %var3%=&set word=&set str3=%1
:process3
for /f "tokens=1,*" %%A in (%str3%) do (set str3=%%B&set word=%%A)
call :reverse_string "%word%" revs
set %var3%=!%var3%! !revs!&set str3="!str3!"
if not !str3!=="" goto process3
set %var3%=!%var3%:~1,1000000!
goto :EOF
	%=== /Reverse each Words Function ===%
