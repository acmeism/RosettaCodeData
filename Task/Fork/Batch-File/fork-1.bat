@echo off

if "%1" neq "" goto %1 || echo Not a valid subroutine

echo Starting mySubroutine1
start "" "%~n0" mySubroutine1
echo.

echo Starting mySubroutine2 6 3
start "" "%~n0" mySubroutine2 6 3
echo.

echo Starting mySubroutine3
start "" "%~n0" mySubroutine3
echo.

:: We wait here for the subroutines to run, but they are running asynchronously
timeout /t 1

for /l %%i in (1,1,3) do (
	for /f "tokens=*" %%j in (output%%i.txt) do (
		set output%%i=%%j
		del output%%i.txt
	)
)
echo.
echo.
echo Return values
echo ----------------------------
echo mySubroutine1: %output1%
echo mySubroutine2: %output2%
echo mySubroutine3: %output3%

pause>nul
exit

:mySubroutine1
echo This is the result of subroutine1 > output1.txt
exit

:mySubroutine2
set /a result=%2+%3
echo %result% > output2.txt
exit

:mySubroutine3
echo mySubroutine1 hasn't been run > output3.txt
if exist output1.txt echo mySubroutine1 has been run > output3.txt
exit
