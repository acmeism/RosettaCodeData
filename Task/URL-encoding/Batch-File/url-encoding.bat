@echo off
setlocal enableextensions enabledelayedexpansion
for /f "tokens=2 delims=:." %%G in ('chcp') do set _codepage=%%G
chcp 65001 >nul
set /p str=||goto:eof
set tempFile="%temp%\hex-urlencoding.txt"
set "letters=ABCDEFGHIKLMNOPQRSTUVWXYZabcdefghiklmnopqrstuvwxyz-._~"
<nul set /p=%letters%>%tempFile%
certutil -encodehex -f %tempFile% %tempFile% 4 >nul
set pos=0
for /f "delims==" %%A in ('set char. 2^>nul') do set "%%A="
for /f "usebackq tokens=*" %%# in (%tempFile%) do for %%h in (%%#) do (
  for %%i in (^!pos^!) do set char.%%h=!letters:~%%i,1!
  set /a pos+=1
)
<nul set /p"=!str!">%tempFile%
certutil -encodehex -f %tempFile% %tempFile% 4 >nul
set str=
for /f "usebackq tokens=*" %%# in (%tempFile%) do for %%h in (%%#) do (
  if defined char.%%h (set "str=!str!!char.%%h!") else (set "str=!str!%%%%h")
)
del %tempFile%
echo(!str!
chcp %_codepage% >nul
