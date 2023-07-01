@echo off

for /f "tokens=1,2 delims= " %%A in ('mode con') do (
	if "%%A"=="Lines:" set line=%%B
	if "%%A"=="Columns:" set cols=%%B
)

echo Lines: %line%
echo Columns: %cols%
exit /b 0
