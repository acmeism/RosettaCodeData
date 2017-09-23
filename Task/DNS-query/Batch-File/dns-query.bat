:: DNS Query Task from Rosetta Code Wiki
:: Batch File Implementation

@echo off

set "domain=www.kame.net"
echo DOMAIN: "%domain%"
echo(
call :DNS_Lookup "%domain%"
pause
exit /b

::Main Procedure
::Uses NSLOOKUP Command. Also uses a dirty "parsing" to detect IP addresses.
:DNS_Lookup [domain]

::Define Variables and the TAB Character
set "dom=%~1"
set "record="
set "reccnt=0"
for /f "delims=" %%T in ('forfiles /p "%~dp0." /m "%~nx0" /c "cmd /c echo(0x09"') do set "TAB=%%T"

setlocal enabledelayedexpansion
for /f "tokens=1* delims=:" %%x in ('nslookup "!dom!" 2^>nul') do (
    set "line=%%x"
    if /i "!line:~0,4!"=="Name" set "record=yes"
    if /i "!line:~0,5!"=="Alias" set "record="
    if "!record!"=="yes" (
        set /a reccnt+=1
        if "%%y"=="" (set "catch_!reccnt!=%%x") else (set "catch_!reccnt!=%%x:%%y")
    )
)
for /l %%c in (1,1,%reccnt%) do (
    if /i "!catch_%%c:~0,7!"=="Address" echo(!catch_%%c:*s:  =!
    if /i "!catch_%%c:~0,1!"=="%TAB%" echo(!catch_%%c:%TAB%  =!
)
endlocal
goto :EOF
