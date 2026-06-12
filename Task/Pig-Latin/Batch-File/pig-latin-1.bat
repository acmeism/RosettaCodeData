@echo off
setlocal enableextensions disabledelayedexpansion
set "inp=%~1"
if not defined inp set /p inp=Enter a string: || goto :eof
set "inp=%inp:!=¬%"
setlocal enabledelayedexpansion
set result=
set out=!inp!
set inpRep=!inp!
set alpha=abcdefghijklmnopqrstuvwxyz '
set alphaU=ABCDEFGHIJKLMNOPQRSTUVWXYZ
for /l %%i in (0,1,27) do (
  %= out-of-bounds positions return nothing =%
  set cases_!alphaU:~%%i,1!=!alphaU:~%%i,1!!alpha:~%%i,1!
  if defined inpRep for %%c in ("!alpha:~%%i,1!") do set inpRep=!inpRep:%%~c=!
)
if not defined inpRep goto passInpRep
%= filter to leave only A-Z, "'" and spaces =%
(
  set s=!inpRep!
  set "len=0"
  %= ss64.com/forum/strlen.html =%
  for %%N in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
    if "!s:~%%N,1!" neq "" (
      set /a "len+=%%N"
      set "s=!s:~%%N!"
    )
  )
  for /f "delims==" %%v in ('set _ 2^>nul') do set "%%v="
  %= circumvent unreplaceable asterisk =%
  set _*=1
  for /l %%i in (0,1,!len!) do for /f eol^= %%c in ("!inpRep:~%%i,1!") do if not defined _%%c (
    set "_%%c=1"
    set inp=!inp:%%c= !
  )
)
:passInpRep
(set lf=^

)
for %%l in ("!lf!") do set "inp=!inp: =%%~l!"
set ay=ay
set ayU=AY
set way=way
set wayU=WAY
set quay=quay
set quayU=QUAY
%= circumvent unreplaceable asterisk =%
for /f "delims=*" %%a in ("!inp!") do (
  set vowelFirst=
  set yVowel= y
  set "str=%%a"
  set "strU=%%a"
  %= check for quotation =%
  if "!str:~0,1!"=="'" set str=!str:~1!
  %= at final position? =%
  for %%s in ("!str:~0,-1!") do if "%%~s'"=="!str!" set "str=%%~s"
  if defined str (
  if /i "!str:~0,1!"=="y" (
    set vowelFirst=1
    for %%c in (a e i o u) do if /i "!str:~1,1!"=="%%c" set yVowel=&set vowelFirst=
  ) else (
    for %%c in (a e i o u) do if /i "!str:~0,1!"=="%%c" set vowelFirst=1
  )
  %= string replacement is case-insensitive =%
  for %%c in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do set strU=!strU:%%c=%%c!
  set capFlag=
  if "!str!"=="!strU!" (
    set t=u
  ) else (
    set t=
    for %%c in ("!str:~0,1!") do if %%c=="!strU:~0,1!" (
      set capFlag=1
      %= first letter to lowercase =%
      %= removing the initial quotation check causes error here =%
      set str=!cases_%%~c:~1!!str:~1!
    )
  )
  for %%u in ("!t!") do if defined vowelFirst (
    set s=!str!!way%%~u!
  ) else if /i "!str:~0,2!"=="qu" (
    set s=!str:~2!!quay%%~u!
  ) else (
    set maxSize=0
    %= strCut won't be set if maxSize is 0 =%
    set strCut=
    for %%c in (a e i o u!yVowel!) do (
      set "t=!str:*%%c=!"
      set "s=##!t!"
      if not "!t!"=="!str!" (
        set "len=0"
        for %%N in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
          if "!s:~%%N,1!" neq "" (
            set /a "len+=%%N"
            set "s=!s:~%%N!"
          )
        )
        if !maxSize! lss !len! for %%i in (!len!) do (
          set strCut=!str:~-%%i!
          set maxSize=%%i
        )
      )
    )
    %= handle words with no vowels =%
    if !maxSize! equ 0 (
      set maxSize=
    ) else (
      set maxSize=:~0,-!maxSize!
    )
    for %%i in ("!maxSize!") do set s=!strCut!!str%%~i!!ay%%~u!
  )
  %= this portion concatenates transformed word with other symbols =%
  for %%r in ("!str!") do (
    if defined capFlag for %%c in ("!s:~0,1!") do set s=!cases_%%~c:~0,1!!s:~1!
    set strRepl=!out:*%%~r=!
    set out=!out!!lf!
    for %%l in ("!lf!") do for /f "delims=" %%s in ("%%~r!strRepl!") do set "result=!result!!out:%%s%%~l=!!s!"
    set out=!strRepl!
  )
  ) %= if defined str =%
)
set "result=!result!!strrepl!"
if not defined result set "result=!out!"
echo/^%result:¬=^^!%
