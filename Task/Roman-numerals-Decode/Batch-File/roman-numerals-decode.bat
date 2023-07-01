@echo off
setlocal enabledelayedexpansion

::Testing...
call :toArabic MCMXC
echo MCMXC = !arabic!
call :toArabic MMVIII
echo MMVIII = !arabic!
call :toArabic MDCLXVI
echo MDCLXVI = !arabic!
call :toArabic CDXLIV
echo CDXLIV = !arabic!
call :toArabic XCIX
echo XCIX = !arabic!
pause>nul
exit/b 0

::The "function"...
:toArabic
set roman=%1
set arabic=
set lastval=
	%== Alternative for counting the string length ==%
set leng=-1
for /l %%. in (0,1,1000) do set/a leng+=1&if "!roman:~%%.,1!"=="" goto break
:break
set /a last=!leng!-1
for /l %%i in (!last!,-1,0) do (
	set n=0
	if /i "!roman:~%%i,1!"=="M" set n=1000
	if /i "!roman:~%%i,1!"=="D" set n=500
	if /i "!roman:~%%i,1!"=="C" set n=100
	if /i "!roman:~%%i,1!"=="L" set n=50
	if /i "!roman:~%%i,1!"=="X" set n=10
	if /i "!roman:~%%i,1!"=="V" set n=5
	if /i "!roman:~%%i,1!"=="I" set n=1
	
	if !n! lss !lastval! (
		set /a arabic-=n
	) else (
		set /a arabic+=n
	)
	set lastval=!n!
)
goto :EOF
