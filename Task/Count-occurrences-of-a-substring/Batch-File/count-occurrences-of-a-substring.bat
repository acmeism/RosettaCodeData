@echo off
setlocal enabledelayedexpansion

	::Main
call :countString "the three truths","th"
call :countString "ababababab","abab"
pause>nul
exit /b
	::/Main

	::Procedure
:countString
	set input=%~1
	set cnt=0

	:count_loop
	set trimmed=!input:*%~2=!
	if "!trimmed!"=="!input!" (echo.!cnt!&goto :EOF)
	set input=!trimmed!
	set /a cnt+=1
	goto count_loop
