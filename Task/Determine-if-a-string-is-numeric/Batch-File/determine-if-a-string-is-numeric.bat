set /a a=%arg%+0 >nul
if %a% == 0 (
	if not "%arg%"=="0" (
		echo Non Numeric.
	) else (
		echo Numeric.
	)
) else (
	echo Numeric.
)
