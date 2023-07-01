%=== Batch Files have no booleans on if command, let alone short-circuit evaluation ===%
%=== I will instead use 1 as true and 0 as false. ===%

@echo off
setlocal enabledelayedexpansion
echo AND
for /l %%i in (0,1,1) do (
for /l %%j in (0,1,1) do (
		echo.a^(%%i^) AND b^(%%j^)
		call :a %%i
		set res=!bool_a!
		if not !res!==0 (
			call :b %%j
			set res=!bool_b!
		)
		echo.=^>	!res!
)
)

echo ---------------------------------
echo OR
for /l %%i in (0,1,1) do (
	for /l %%j in (0,1,1) do (
		echo a^(%%i^) OR b^(%%j^)
		call :a %%i
		set res=!bool_a!
		if !res!==0 (
			call :b %%j
			set res=!bool_b!
		)
		echo.=^>	!res!
	)
)
pause>nul
exit /b 0


::----------------------------------------
:a
echo.	calls func a
set bool_a=%1
goto :EOF

:b
echo.	calls func b
set bool_b=%1
goto :EOF
