@echo off
setlocal enabledelayedexpansion

set "Temp_File=%TMP%\NSLOOKUP_%RANDOM%.TMP"
set "Domain=www.kame.net"

echo.Domain: %Domain%
echo.
echo.IP Addresses:

	::The Main Processor
nslookup %Domain% >"%Temp_File%" 2>nul
for /f "tokens=*" %%A in (
'findstr /B /C:"Address" "%Temp_File%" ^& findstr /B /C:"	" "%Temp_File%"'
) do (
	set data=%%A
	echo.!data:*s:  =!|findstr /VBC:"192.168." /VBC:"127.0.0.1"
)
del /Q "%Temp_File%"
echo.
pause
