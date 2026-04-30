@echo off
setlocal enableextensions enabledelayedexpansion
call :getdns -4
call :getdns -6
goto :eof
:getdns
for /f "tokens=*" %%g in ('ping %1 -n 1 www.kame.net') do (
    set a=%%g
    if "!a:~0,15!" equ "Ping statistics" (
        echo !a:~20,-1!
        goto :eof
    )
)
goto :eof
