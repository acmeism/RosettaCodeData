@echo off
setlocal
set /a "a=%~1, b=%~2"
call :num2bin %a% aStr
call :num2bin %b% bStr

::AND
set /a "val=a&b"
call :display "%a% AND %b%" %val% %aStr% %bStr%

::OR
set /a "val=a|b"
call :display "%a% OR %b%" %val% %aStr% %bStr%

::XOR
set /a "val=a^b"
call :display "%a% XOR %b%" %val% %aStr% %bStr%

::NOT
set /a "val=~a"
call :display "NOT %a%" %val% %aStr%

::LEFT SHIFT
set /a "val=a<<b"
call :display "%a% Left Shift %b%" %val% %aStr%

::ARITHMETIC RIGHT SHIFT
set /a "val=a>>b"
call :display "%a% Arithmetic Right Shift %b%" %val% %aStr%

::The remaining operations do not have native support
::The implementations use additional operators
::  %% = mod
::  ! = logical negation where !(zero)=1 and !(non-zero)=0
::  * = multiplication
::  - = subtraction

::LOGICAL RIGHT SHIFT (No native support)
set /a "val=(a>>b)&~((0x80000000>>b-1)*!!b)"
call :display "%a% Logical Right Shift %b%" %val% %aStr%

::ROTATE LEFT (No native support)
set /a "val=(a<<b%%32) | (a>>32-b%%32)&~((0x80000000>>31-b%%32)*!!(32-b%%32))"
call :display "%a% Rotate Left %b%" %val% %aStr%

::ROTATE RIGHT (No native support)
set /a "val=(a<<32-b%%32) | (a>>b%%32)&~((0x80000000>>b%%32-1)*!!(b%%32)) "
call :display "%a% Rotate Right %b%" %val% %aStr%

exit /b


:display op result aStr [bStr]
echo(
echo %~1 = %2
echo %3
if "%4" neq "" echo %4
call :num2bin %2
exit /b


:num2bin    IntVal [RtnVar]
  setlocal enableDelayedExpansion
  set n=%~1
  set rtn=
  for /l %%b in (0,1,31) do (
    set /a "d=n&1, n>>=1"
    set rtn=!d!!rtn!
  )
  (endlocal & rem -- return values
    if "%~2" neq "" (set %~2=%rtn%) else echo %rtn%
  )
exit /b
