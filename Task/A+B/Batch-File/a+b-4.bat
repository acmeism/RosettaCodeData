::aplusb.cmd
@echo off
setlocal
set /p a="Input stream: "
call :add %a%
echo %res%
endlocal
goto :eof

:add
set /a res=res+%1
shift
if "%1" neq "" goto :add
