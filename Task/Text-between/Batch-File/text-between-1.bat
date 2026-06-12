@echo off
setlocal enableextensions enabledelayedexpansion
if defined _textbetween_main goto main
(
for /f "tokens=2 delims=:." %%g in ('chcp') do set codepage=%%g
chcp 65001 >nul
set _textbetween_main=1
:: ctrl-c will return control to the parent process
cmd /c "%~f0" %~1
chcp !codepage! >nul
exit /b
)
:main
if "%~1"=="" (set redir=) else ( set "redir=<%1")
(
set/p text=Text: || goto :eof
set/p start=Start delimiter: || goto :eof
set/p end=End delimiter: || goto checkStart
)%redir%
for %%l in ("!lf!") do for %%i in (text start end) do for /f "eol= delims=" %%s in ("!%%i!") do set "%%i=%%~s"
if not "!start!"=="start" (
  set "tempstr=!text:*%start%=!"
  if "!tempstr!"=="!text!" goto nothing
  set "text=!tempstr!"
)
if "%end%"=="end" goto return
  set "tempstr=!text:*%end%=!"
  if not "!text!"=="!tempstr!" set "text=!text:%end%%tempstr%=!"
  if not defined text goto nothing
:return
echo:Output: "!text!"
goto:eof
:nothing
echo:Output: ""
