@echo off
setlocal enableextensions enabledelayedexpansion
set /p a=
set /p b=
set /a i=0
for %%i in (^^%b% %b% %b%$) do (
echo/%a% | findstr /rc:"%%i" >nul 2>nul && set contain.!i!=Yes|| set contain.!i!=No
set /a i+=1
)
echo "%a%" starts with "%b%": %contain.0%
echo "%a%" ends with "%b%": %contain.1%
echo "%a%" contains "%b%": %contain.2%
