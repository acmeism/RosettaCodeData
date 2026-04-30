@echo off
setlocal enableextensions enabledelayedexpansion
set /p str=||goto :eof

set orig=abcdefghijklmnopqrstuvwxyz
set ciphLwr=nopqrstuvwxyzabcdefghijklm
set ciphUpr=NOPQRSTUVWXYZABCDEFGHIJKLM
for /f "delims==" %%A in ('set char. 2^>nul') do set "%%A="
for /l %%i in (0,1,25) do for %%c in (^!orig:~%%i^,1^!) do set char.%%c=%%c!ciphLwr:~%%i,1!!ciphUpr:~%%i,1!

:: string length
:: https://ss64.com/forum/strlen.html
:: !str! instead of %str% to not resolve anything after percent expansion
set "tempFile=%temp%\strlen-rot13.tmp"
echo(!str!>"%tempFile%"
for %%F in ("%tempFile%") do set /a len=%%~zF-3
del "%tempFile%"

:: usebackq and '"..."' in for/f : handles spaces
::: plain for resolves wildcard characters ("?" and "*") so it isn't used
:: ^ : handles exclamation marks
set buffer=
for /l %%i in (0,1,%len%) do for /f "usebackq eol= delims=" %%c in ('"!str:~%%i,1!"') do (
  if defined char.%%~c (
    if "%%~c"=="!char.%%~c:~0,1!" (set aug=1) else (set aug=2)
    for %%d in ("!aug!") do set "buffer=!buffer!!char.%%~c:~%%~d,1!"
  ) else (set "buffer=!buffer!^%%~c")
)
echo(!buffer!
