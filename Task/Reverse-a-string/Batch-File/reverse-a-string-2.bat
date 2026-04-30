@echo off
setlocal enableextensions enabledelayedexpansion
set str=%1
::strlen4 from https://ss64.com/forum/strlen.html
set "tempFile=%temp%\strlen-reverse.tmp"
echo(%str%>"%tempFile%"
for %%F in ("%tempFile%") do set /a len=%%~zF-3
del "%tempFile%"
<nul (
for /l %%i in (%len%,-1,0) do set/p=!str:~%%i,1!
)
