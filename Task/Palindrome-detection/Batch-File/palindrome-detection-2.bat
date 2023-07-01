@echo off
set /p testString=Your string (all same case please) :
call :isPalindrome result %testString: =%
if %result%==1 echo %testString% is a palindrome
if %result%==0 echo %testString% isn't a palindrome
pause
goto :eof

:isPalindrome
	set %1=0
	set string=%2
	if "%string:~2,1%"=="" (
		set %1=1
		goto :eof
	)
	if "%string:~0,1%"=="%string:~-1%" (
		call :isPalindrome %1 %string:~1,-1%
	)
	goto :eof
