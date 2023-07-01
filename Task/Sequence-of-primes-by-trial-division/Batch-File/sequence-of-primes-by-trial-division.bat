@echo off
::Prime list using trial division
:: Unbounded (well, up to 2^31-1, but you'll kill it before :)
:: skips factors of 2 and 3 in candidates and in divisors
:: uses integer square root to find max divisor to test
:: outputs numbers in rows of 10 right aligned primes
setlocal enabledelayedexpansion

cls
echo prime list
set lin=    0:
set /a num=1, inc1=4, cnt=0
call :line 2
call :line 3


:nxtcand
set /a num+=inc1, inc1=6-inc1,div=1, inc2=4
call :sqrt2 %num% & set maxdiv=!errorlevel!

:nxtdiv
set /a div+=inc2, inc2=6-inc2, res=(num%%div)
if %div% gtr !maxdiv! call :line %num% &  goto nxtcand
if %res%  equ 0 (goto :nxtcand ) else ( goto nxtdiv)

:sqrt2   [num] calculates integer square root
if %1 leq 0 exit /b 0
set /A "x=%1/(11*1024)+40, x=(%1/x+x)>>1, x=(%1/x+x)>>1, x=(%1/x+x)>>1, x=(%1/x+x)>>1, x=(%1/x+x)>>1, x+=(%1-x*x)>>31,sq=x*x
if sq gtr %1 set x-=1
exit /b !x!
goto:eof

:line    formats output in 10 right aligned columns
set num1=      %1
set lin=!lin!%num1:~-7%
set /a cnt+=1,res1=(cnt%%10)
if %res1% neq 0 goto:eof
echo %lin%
set cnt1=    !cnt!
set lin=!cnt1:~-5!:
goto:eof
