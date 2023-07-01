@echo off & setlocal enabledelayedexpansion

:: Binary Chop Algorithm - Michael Sanders 2017
::
:: example output...
::
:: binary chop algorithm vs. standard for loop
::
:: number to find 941
:: for loop required 941 iterations
:: binchop required 10 iterations

:setup

   set x=1
   set y=999
   set /a z=(%random% * (%y% - 1) / 32768 + 1)

:pseudoarray

   for /l %%q in (%x%,1,%y%) do set /a array[%%q]=%%q

:std4loop

   for /l %%q in (%x%,1,%y%) do (
      if !array[%%q]!==%z% (set f=%%q& goto :binchop)
   )

:binchop

   if !x! leq !y! (
      set /a i+=1
      set /a "p=(!x!+!y!)/2"
      call set /a t=%%array[!p!]%%
      if !t! equ !z! (set b=!i!& goto :done)
      if !t! lss !z! (set /a x=!p!+1) else (set /a y=!p!-1)
      goto :binchop
   )

:done

   cls
   echo binary chop algorithm vs. standard for loop...
   echo.
   echo . number to find !z!
   echo . for loop required !f! iterations
   echo . binchop required !b! iterations
   endlocal & exit /b 0
