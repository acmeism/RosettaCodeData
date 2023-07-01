@echo off
setlocal enabledelayedexpansion
	%== Calls the "function" ==%
call :ModInv 42 2017 result
echo !result!
call :ModInv 40 1 result
echo !result!
call :ModInv 52 -217 result
echo !result!
call :ModInv -486 217 result
echo !result!
call :ModInv 40 2018 result
echo !result!
pause>nul
exit /b 0

	%== The "function" ==%
:ModInv
	set a=%1
	set b=%2

	if !b! lss 0 (set /a b=-b)
	if !a! lss 0 (set /a a=b - ^(-a %% b^))

	set t=0&set nt=1&set r=!b!&set /a nr=a%%b

	:while_loop
	if !nr! neq 0 (
		set /a q=r/nr
		set /a tmp=nt
		set /a nt=t - ^(q*nt^)
		set /a t=tmp

		set /a tmp=nr
		set /a nr=r - ^(q*nr^)
		set /a r=tmp
		goto while_loop
	)

	if !r! gtr 1 (set %3=-1&goto :EOF)
	if !t! lss 0 set /a t+=b
	set %3=!t!
	goto :EOF
