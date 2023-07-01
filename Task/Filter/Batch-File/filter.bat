@echo off
setlocal enabledelayedexpansion

set numberarray=1 2 3 4 5 6 7 8 9 10
for %%i in (%numberarray%) do (
  set /a tempcount+=1
  set numberarray!tempcount!=%%i
)

echo Filtering all even numbers from numberarray into newarray...
call:filternew numberarray
echo numberarray - %numberarray%
echo newarray    -%newarray%
echo.
echo Filtering numberarray so that only even entries remain...
call:filterdestroy numberarray
echo numberarray -%numberarray%
pause>nul
exit /b

:filternew
set arrayname=%1
call:arraylength %arrayname%
set tempcount=0
for /l %%i in (1,1,%length%) do (
  set /a cond=!%arrayname%%%i! %% 2
  if !cond!==0 (
    set /a tempcount+=1
    set newarray!tempcount!=!%arrayname%%%i!
    set newarray=!newarray! !%arrayname%%%i!
  )
)
exit /b

:filterdestroy
set arrayname=%1
call:arraylength %arrayname%
set tempcount=0
set "%arrayname%="
for /l %%i in (1,1,%length%) do (
  set /a cond=!%arrayname%%%i! %% 2
  if !cond!==0 (
    set /a tempcount+=1
    set %arrayname%!tempcount!=!%arrayname%%%i!
    set %arrayname%=!%arrayname%! !%arrayname%%%i!
  )
)
exit /b

:arraylength
set tempcount=0
set lengthname=%1
set length=0
:lengthloop
set /a tempcount+=1
if "!%lengthname%%tempcount%!"=="" exit /b
set /a length+=1
goto lengthloop
