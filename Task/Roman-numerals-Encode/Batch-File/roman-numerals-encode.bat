@echo off
setlocal enabledelayedexpansion

set cnt=0&for %%A in (1000,900,500,400,100,90,50,40,10,9,5,4,1) do (set arab!cnt!=%%A&set /a cnt+=1)
set cnt=0&for %%R in (M,CM,D,CD,C,XC,L,XL,X,IX,V,IV,I) do (set rom!cnt!=%%R&set /a cnt+=1)

::Testing
call :toRoman 2009
echo 2009 = !result!
call :toRoman 1666
echo 1666 = !result!
call :toRoman 3888
echo 3888 = !result!
pause>nul
exit/b 0

::The "function"...
:toRoman
set value=%1
set result=

for /l %%i in (0,1,12) do (
	set a=%%i
	call :add_val
)
goto :EOF

:add_val
if !value! lss !arab%a%! goto :EOF
set result=!result!!rom%a%!
set /a value-=!arab%a%!
goto add_val
