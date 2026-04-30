@echo off
setlocal enableextensions enabledelayedexpansion
set /p str=|| goto:eof
(set LF=^

)
for /f "delims==" %%a in ('set h. 2^>nul') do set "%%a="
set hexlist=
for %%L in ("!LF!") DO set tempstr=!str:%%=%%~L!
for /f "skip=1 tokens=* delims=" %%a in ("!tempstr!") do (
  set "cur=%%a"
  set hex=!cur:~0,2!
  if not defined h.!hexlist! (
    set h.!hexlist!=1
    set hexlist=!hexlist! !hex!
  )
)
set hex=%temp%\hex.txt
echo/!hexlist!>"%hex%"
certutil -f -decodehex "%hex%" "%hex%" >nul
for /f "tokens=2 delims=:." %%G in ('chcp') do set _codepage=%%G
chcp 437>nul
set/p tempstr=<"%hex%"&& (
  set cur=0
  for %%i in (!hexlist!) do (
    for %%j in ("!cur!") do for %%p in ("%%%%i=!tempstr:~%%~j,1!") do set str=!str:%%~p!
    set /a cur+=1
  )
) || for %%i in (!hexlist!) do set str=!str:%%%%i=!
:print
echo/!str!>"%hex%"
chcp 65001>nul
type "%hex%"
del "%hex%"
chcp %_codepage%>nul
