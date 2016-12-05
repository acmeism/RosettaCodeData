:: DNS Query Task from Rosetta Code Wiki
:: Batch File Implementation

@echo off

set "domain=www.kame.net"
echo DOMAIN: "%domain%"
echo.
call :DNS_Lookup "%domain%"
echo.
pause
exit /b

::Main Procedure
::Uses NSLOOKUP Command and a Temporary File
::Also uses a dirty "parsing" to detect IP addresses.

:DNS_Lookup [domain]
setlocal enabledelayedexpansion
for /f "delims=" %%T in ('forfiles /p "%~dp0." /m "%~nx0" /c "cmd /c echo(0x09"') do set "TAB=%%T"
set "temp_file=%TMP%\NSLOOKUP_%RANDOM%.TMP"

set "record="
for /f "tokens=1* delims=:" %%x in ('nslookup "%~1" 2^>nul') do (
	set "line=%%x"
	if "!line:~0,4!"=="Name" set "record=yes"
	if "!line:~0,5!"=="Alias" set "record="
	if "!record!"=="yes" (
		if "%%y"=="" (echo %%x>>"%temp_file%") else (echo %%x:%%y>>"%temp_file%")
	)
)
if exist "%temp_file%" (
	for /f "tokens=*" %%a in (
		'findstr /BC:"Address" "%temp_file%" ^& findstr /BC:"%TAB%" "%temp_file%"'
	) do (set "data=%%a"&echo !data:*s:  =!)
	del /q "%temp_file%"
) else (echo Connection to domain failed.)
goto :EOF
