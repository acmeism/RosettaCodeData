@echo off

::The Main Thing...
cls
echo.
call :reverse "---------- Ice and Fire ------------"
call :reverse
call :reverse "fire, in end will world the say Some"
call :reverse "ice. in say Some"
call :reverse "desire of tasted I've what From"
call :reverse "fire. favor who those with hold I"
call :reverse
call :reverse "... elided paragraph last ..."
call :reverse
call :reverse "Frost Robert -----------------------"
echo.
pause>nul
exit
::/The Main Thing...

::The Function...
:reverse
set reversed=&set word=&set str=%1
:process
for /f "tokens=1,*" %%A in (%str%) do (
	set str=%%B
	set word=%%A
)
set reversed=%word% %reversed%
set str="%str%"
if not %str%=="" goto process

echo.%reversed%
goto :EOF
::/The Function...
