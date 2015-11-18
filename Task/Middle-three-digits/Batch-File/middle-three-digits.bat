@echo off
setlocal enabledelayedexpansion

	%== Initialization ==%
set "numbers=123, 12345, 1234567, 987654321, 10001, -10001, -123, -100, 100, -12345, 1, 2, -1, -10, 2002, -2002, 0"

	%== The Main Thing ==%
for %%N in (%numbers%) do (
	call :middle3 %%N
)
echo.
pause
exit /b 0
	%==/The Main Thing ==%

	%== The Procedure ==%
:middle3

	set str=%1
	%== Making sure that str is positive ==%
	if !str! lss 0 set /a str*=-1

	%== Alternative for finding the string length ==%
	%== But this has a limit of 1000 characters ==%
	set leng=0&if not "!str!"=="" for /l %%. in (0,1,1000) do if not "!str:~%%.,1!"=="" set /a leng+=1

	if !leng! lss 3 (
		echo.%~1:		[ERROR] Input too small.
		goto :EOF
	)

	set /a "test2=leng %% 2,trimmer=(leng - 3) / 2"

	if !test2! equ 0 (
		echo.%~1:		[ERROR] Even number of digits.
		goto :EOF
	)

	%== Passed the tests. Now, really find the middle 3 digits... ==%
	if !trimmer! equ 0 (
		echo.%~1:		!str!
	) else (
		echo.%~1:		!str:~%trimmer%,-%trimmer%!
	)
	goto :EOF
	%==/The Procedure ==%
