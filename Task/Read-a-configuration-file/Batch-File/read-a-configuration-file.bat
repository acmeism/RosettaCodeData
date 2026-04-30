@echo off
setlocal enableextensions enabledelayedexpansion
for /f "delims==" %%a in ('set 2^>nul') do set "%%a="
(set #lf=^

)
for /f "usebackq tokens=1* eol=#" %%i in ("%~1") do (
  set "#temp=%%i%%j"
  if "!#temp:~0,1!"==";" (set !#temp:~1!=false) else (
  set "#temp=%%j"
  call :strip !#temp!
  if "!#temp!"=="" (set %%i=true) else (
  for %%l in ("!#lf!") do set "#list=!#temp:,=%%~l!"
  if "!#temp!"=="!#list!" (set "%%i=!#temp!") else (
    set #count=1
    for /f "tokens=*" %%l in ("!#list!") do (
      call :strip %%l
      set "%%i(!#count!)=!#temp!"
      set /a #count+=1
    )
  )))
)
set #lf=
set #count=
set #temp=
set #list=
set
goto:eof
:strip %= strip whitespaces =%
set "#temp=%*"
