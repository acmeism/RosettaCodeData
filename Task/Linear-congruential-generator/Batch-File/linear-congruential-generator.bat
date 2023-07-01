@echo off & setlocal enabledelayedexpansion

echo BSD Rand
set /a a=0,cnt=1
:b
set /a "a=1103515245 *a+12345,a&=0x7fffffff, cnt+=1"
call:prettyprint !cnt! !a!
if !cnt! leq 10 goto :b

echo.
echo Microsoft Rand
set /a a=0,cnt=1
:c
set /a "a=214013 *a+2531011,a&=0x7fffffff, b=a>>16,cnt+=1"
call:prettyprint !cnt! !b!
if !cnt! lss 10 goto :c
pause
goto:eof

:prettyprint
set p1= %1
set p2=        %2
echo %p1:~-2%  %p2:~-10%
goto:eof
