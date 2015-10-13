@echo off
setlocal enabledelayedexpansion

::The Main Thing...
set choices="fee fie","huff and puff","mirror mirror","tick tock"
set "quest=Which is from the three pigs?"
call :select
pause>nul
exit /b 0
::/The Main Thing.

::The Function...
:select
set number=0
for %%A in (%choices%) do set tmpvar=%%A&set /a number+=1&set opt!number!=!tmpvar:"=!
:tryagain
cls&echo.
for /l %%A in (1,1,%number%) do echo. Option %%A - !opt%%A!
echo.
set /p input=%quest%
for /l %%A in (1,1,%number%) do (
	if !input! equ %%A echo.&echo.You chose option %%A - !opt%%A!&goto :EOF
)
echo.
echo.Invalid Input. Please try again...
pause>nul
goto tryagain
::/The Function.
