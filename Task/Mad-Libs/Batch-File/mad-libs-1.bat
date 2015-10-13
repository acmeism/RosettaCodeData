::Save this as MADLIBS.BAT

@echo off
setlocal enabledelayedexpansion
	%== Check if there is no arguments ==%
if "%~1"=="" (
	echo.
	echo.[Mad Libs - Batch File Implementation]
	echo.
	echo.Usage: MADLIBS [file]
	echo.
	exit /b 1
)
if not exist "%~f1" (echo.File not found.&exit /b 1)

echo.
	%== Read the text file ==%
echo.[Mad Libs - Batch File Implementation]
echo.
for /f "tokens=* eol=_" %%A in (%~sf1) do (
	set /a cnt+=1
	set "line!cnt!=%%A"
)
	%== User input the missing parts ==%
for /l %%. in (1,1,!cnt!) do (
	call :proc_line	"%%."
)
	%== Display the edited story... ==%
echo.
echo.The Story:
echo.
for /l %%? in (1,1,!cnt!) do (
	echo.	!line%%?!
)
echo.
exit /b 0

	%== The main processor of the story ==%
:proc_line
set "str=!line%~1!"
:loop
if "!str!"=="" goto :EOF
for /f "tokens=1,* delims=<" %%M in ("!str!") do (
	for /f "tokens=1,* delims=>" %%X in ("%%M") do (
		if not "%%M"=="%%X" (
			set "temp_var=%%X"
			if not "!temp_var: =!"=="" (
				set "input="
				set /p "input=Enter a value for [%%X]?"
				call :subst_input
			)
		)
	)
)
set "str=!line%~1!"
for /f "tokens=1,* delims=<" %%M in ("!str!") do (set str=%%N)
goto loop

	%== This Substitutes the input to the blank ==%
:subst_input
set "chk_brack=!input:>=!"
set "chk_brack=!chk_brack:<=!"
set "chk_brack=!chk_brack:%%=!"
for /l %%. in (1,1,!cnt!) do (
	if "!line%%.: =!"==" =" set "line%%.= "
	if "!chk_brack!"=="!input!" (
		call set "line%%.=%%line%%.:<%%X>=!input!%%"
	) else (set "line%%.=!line%%.:<%%X>=!")
)
goto :EOF
