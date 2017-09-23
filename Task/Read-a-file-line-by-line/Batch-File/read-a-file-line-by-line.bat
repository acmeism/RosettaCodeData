@echo off
rem delayed expansion must be disabled before the FOR command.
setlocal disabledelayedexpansion
for /f "tokens=1* delims=]" %%A in ('type "File.txt"^|find /v /n ""') do (
	set var=%%B
	setlocal enabledelayedexpansion
		echo(!var!
	endlocal
)
