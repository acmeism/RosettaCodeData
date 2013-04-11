@echo off
setlocal enabledelayedexpansion
if "%1" equ "" goto :eof
call :hailstone %1 seq cnt
echo %seq%
goto :eof

:hailstone
set num=%1
set %2=%1

:loop
if %num% equ 1 goto :eof
call :iseven %num% res
if %res% equ T goto divideby2
set /a num = (3 * num) + 1
set %2=!%2! %num%
goto loop
:divideby2
set /a num = num / 2
set %2=!%2! %num%
goto loop

:iseven
set /a tmp = %1 %% 2
if %tmp% equ 1 (
	set %2=F
) else (
	set %2=T
)
goto :eof
