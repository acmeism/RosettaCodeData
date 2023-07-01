@echo off
setlocal enabledelayedexpansion

set target=M E T H I N K S @ I T @ I S @ L I K E @ A @ W E A S E L
set chars=A B C D E F G H I J K L M N O P Q R S T U V W X Y Z @

set tempcount=0
for %%i in (%target%) do (
  set /a tempcount+=1
  set target!tempcount!=%%i
)
call:parent

echo  %target%
echo  --------------------------------------------------------

:loop
call:fitness parent
set currentfit=%errorlevel%
if %currentfit%==28 goto end
echo %parent% - %currentfit% [%attempts%]
set attempts=0

:innerloop
set /a attempts+=1
title Attemps - %attempts%
call:mutate %parent%
call:fitness tempparent
set newfit=%errorlevel%
if %newfit% gtr %currentfit% (
  set tempcount=0
  set "parent="
  for %%i in (%tempparent%) do (
    set /a tempcount+=1
    set parent!tempcount!=%%i
    set parent=!parent! %%i
  )
  goto loop
)
goto innerloop

:end
echo %parent% - %currentfit% [%attempts%]
echo Done.
exit /b

:parent
set "parent="
for /l %%i in (1,1,28) do (
  set /a charchosen=!random! %% 27 + 1
  set tempcount=0
  for %%j in (%chars%) do (
    set /a tempcount+=1
    if !charchosen!==!tempcount! (
      set parent%%i=%%j
      set parent=!parent! %%j
    )
  )
)
exit /b

:fitness
set fitness=0
set array=%1
for /l %%i in (1,1,28) do if !%array%%%i!==!target%%i! set /a fitness+=1
exit /b %fitness%

:mutate
set tempcount=0
set returnarray=tempparent
set "%returnarray%="
for %%i in (%*) do (
  set /a tempcount+=1
  set %returnarray%!tempcount!=%%i
  set %returnarray%=!%returnarray%! %%i
)
set /a tomutate=%random% %% 28 + 1
set /a mutateto=%random% %% 27 + 1
set tempcount=0
for %%i in (%chars%) do (
  set /a tempcount+=1
  if %mutateto%==!tempcount! (
    set %returnarray%!tomutate!=%%i
  )
)
set "%returnarray%="
for /l %%i in (1,1,28) do set %returnarray%=!%returnarray%! !%returnarray%%%i!
exit /b
