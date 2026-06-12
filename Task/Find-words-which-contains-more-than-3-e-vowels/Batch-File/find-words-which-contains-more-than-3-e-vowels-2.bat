@echo off
setlocal enableextensions enabledelayedexpansion
for /f "tokens=* delims=" %%g in (unixdict.txt) do (
  set "str=%%g"
  set tstr=!str:*a= !
  set tstr=!tstr:*i= !
  set tstr=!tstr:*o= !
  set tstr=!tstr:*u= !
  if "!tstr!"=="!str!" (
    set str="!str:e=" "!"
    set count=0
    for %%i in (!str!) do set/a count+=1
    if !count! gtr 4 echo:%%g
  )
)
