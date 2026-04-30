@echo off
setlocal enableextensions
set /p ab=
set res=0
for %%i in (%ab%) do set /a res+=%%i
echo %res%
