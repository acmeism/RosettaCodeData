@echo off
setlocal enableextensions enabledelayedexpansion
for /f %%v in ('set _ 2^>nul') do set "%%v="
set "p=((X)+((X)/4)-((X)/100)+((X)/400))%%7"
(for /l %%i in (2000,1,2100) do (
  set /a "func=^!(!p:X=%%i!-4) | ^!(!p:X=%%i-1!-3)"
  if !func! equ 1 set /p=%%i
))<nul
