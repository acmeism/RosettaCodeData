@echo off
:strip String StripSet OutVar
setlocal enableextensions
set "str=%~1"
set "stripset=%~2"
setlocal enabledelayedexpansion
::strlen4 from https://ss64.com/forum/strlen.html
set "tempFile=%temp%\strlen-strip.tmp"
echo(%stripset%>"%tempFile%"
for %%F in ("%tempFile%") do set /a len=%%~zF-3
del "%tempFile%"
::call set is slow
for /l %%i in (0,1,%len%) do (
for %%c in (!stripset:~%%i^,1!) do set str=!str:%%c=!
)
echo !str!
