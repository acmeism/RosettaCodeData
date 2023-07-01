@echo off
setlocal enabledelayedexpansion
set num1=12
set num2=18

call :lcm %num1% %num2%
exit /b

:lcm <input1> <input2>
if %2 equ 0 (
	set /a lcm = %num1%*%num2%/%1
	echo LCM = !lcm!
	pause>nul
	goto :EOF
)
set /a res = %1 %% %2
call :lcm %2 %res%
goto :EOF
