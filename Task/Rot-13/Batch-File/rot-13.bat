@echo off & setlocal enabledelayedexpansion

:: ROT13 obfuscator Michael Sanders - 2017
::
:: example: rot13.cmd Rire abgvpr cflpuvpf arire jva gur ybggrel?

:setup

   set str=%*
   set buf=%str%
   set len=0

:getlength

   if not defined buf goto :start
   set buf=%buf:~1%
   set /a len+=1
   goto :getlength

:start

   if %len% leq 0 (echo rot13: zero length string & exit /b 1)
   set abc=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz
   set nop=NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm
   set r13=
   set num=0
   set /a len-=1

:rot13

   for /l %%x in (!num!,1,%len%) do (
      set log=0
      for /l %%y in (0,1,51) do (
         if "!str:~%%x,1!"=="!abc:~%%y,1!" (
            call set r13=!r13!!nop:~%%y,1!
            set /a num=%%x+1
            set /a log+=1
            if !num! lss %len% goto :rot13
         )
      )
      if !log!==0 call set r13=!r13!!str:~%%x,1!
   )

:done

   echo !r13!
   endlocal & exit /b 0
