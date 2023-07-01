@echo off

:: Supports all ASCII characters and codes from 34-126 with the exceptions of:
:: 38  &
:: 60  <
:: 62  >
:: 94  ^
:: 124 |

:_main
call:_toCode a
call:_toChar 97
pause>nul
exit /b

:_toCode
setlocal enabledelayedexpansion
set codecount=32

for /l %%i in (33,1,126) do (
  set /a codecount+=1
  cmd /c exit %%i
  if %1==!=exitcodeAscii! (
    echo !codecount!
    exit /b
  )
)

:_toChar
setlocal
cmd /c exit %1
echo %=exitcodeAscii%
exit /b
