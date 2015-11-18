@echo off
setlocal enabledelayedexpansion

set num1=18446744073709551616
set num2=18446744073709551616

set limit_a=-1&set limit_b=-1&set length=0
for %%A in (1,2) do for /l %%B in (0,1,9) do set num%%A=!num%%A:%%B=%%B !
for %%. in (!num1!) do set/a limit_a+=1&set a1=%%.!a1!
for %%. in (!num2!) do set/a limit_b+=1&set a2=%%.!a2!

for /l %%a in (0,1,!limit_a!) do (
for /l %%b in (0,1,!limit_b!) do (
	set/a pos=%%a+%%b
	set/a next=!pos!+1
	set/a temp0=result!pos!
	set/a result!pos!=!a1:~%%a,1!*!a2:~%%b,1!
	if !temp0! equ 0 set/a length+=1
	if !pos! lss !length! set/a result!pos!+=!temp0!

	set/a temp0=result!pos!
	set/a temp1=result!next!

	if !temp0! gtr 9 (
		set/a result!next!=!temp0!/10
		set temp2=!length!
		if !temp1! equ 0 set/a length+=1
		if !next! lss !temp2! set/a result!next!+=!temp1!
		set/a result!pos!=!temp0!%%10
	)
)
)
for /l %%. in (0,1,!length!) do set product=!result%%.!!product!
echo.!product!
echo.
pause>nul
exit /b 0
