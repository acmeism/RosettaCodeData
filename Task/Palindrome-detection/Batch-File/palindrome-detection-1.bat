@echo off
setlocal enabledelayedexpansion
set /p string=Your string :
set count=0
:loop
	if "!%string%:~%count%,1!" neq "" (
		set reverse=!%string%:~%count%,1!!reverse!
		set /a count+=1
		goto loop
	)
set palindrome=isn't
if "%string%"=="%reverse%" set palindrome=is
echo %string% %palindrome% a palindrome.
pause
exit
