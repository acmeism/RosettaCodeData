@echo off
for /f %%. in ('forfiles /m "%~nx0" /c "cmd /c echo 0x07"') do set bell=%%.
echo %bell%
