:: http://rosettacode.org/wiki/Call_a_function
:: Demonstrate the different syntax and semantics provided for calling a function.

@echo off

echo Calling myFunction1
call:myFunction1
echo.

echo Calling myFunction2 11 8
call:myFunction2 11 8
echo.

echo Calling myFunction3 /fi and saving the output into %%filecount%%
call:myFunction3 /fi
echo.%filecount%
echo.

echo Calling myFunction4 1 2 3 4 5
call:myFunction4 1 2 3 4 5
echo.

echo Calling myFunction5 "filename=test.file" "filepath=C:\Test Directory\"
call:myFunction5 "filename=test.file" "filepath=C:\Test Directory\"
echo.
echo Calling myFunction5 "filepath=C:\Test Directory\" "filename=test.file"
call:myFunction5 "filepath=C:\Test Directory\" "filename=test.file"
echo.

pause>nul
exit

:: Requires no arguments
:myFunction1
	echo myFunction1 has been called.
	goto:eof

:: Fixed number of arguments (%a% & %b%)
:myFunction2
	:: Returns %a% + %b%
	setlocal
	set /a c=%~1+%~2
	endlocal & echo %c%
	goto:eof

:: Optional arguments
:myFunction3
	:: Returns the amount of folders + files in the current directory
	:: /fi Returns only file count
	:: /fo Returns only folder count
	
	setlocal
	set count=0
	
	if "%~1"=="" set "command=dir /b"
	if "%~1"=="/fi" set "command=dir /b /A-d"
	if "%~1"=="/fo" set "command=dir /b /Ad"

	for /f "usebackq" %%i in (`%command%`) do set /a count+=1
	
	endlocal & set filecount=%count%
	goto:eof

:: Variable number of arguments
:myFunction4
	:: Returns sum of arguments
	setlocal
	:myFunction4loop
	set sum=0
	for %%i in (%*) do set /a sum+=%%i
	endlocal & echo %sum%
	goto:eof

:: Named Arguments (filepath=[path] & filename=[name])
:myFunction5
	:: Returns the complete path based off the 2 arguments
	if "%~1"=="" then goto:eof
	setlocal enabledelayedexpansion
	set "param=%~1"
	
	for /l %%i in (1,1,2) do (
		for /f "tokens=1,2 delims==" %%j in ("!param!") do set %%j=%%k
		set "param=%~2"
	)
	endlocal & echo.%filepath%%filename%
	goto:eof
