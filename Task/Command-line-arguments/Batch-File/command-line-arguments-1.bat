@echo off
setlocal enabledelayedexpansion

set Count=0
:loop
if not "%1"=="" (
   set /a count+=1
   set parameter[!count!]=%1
   shift
   goto loop
)

for /l %%a in (1,1,%count%) do (
   echo !parameter[%%a]!
)
