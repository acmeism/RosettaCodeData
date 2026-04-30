@echo off
setlocal enableextensions enabledelayedexpansion
set catch=
for /f "skip=4 tokens=*" %%g in ('nslookup www.kame.net 2^>nul') do (
    set "a=%%g"
    if defined catch echo %%g
    if "!a:~0,7!" equ "Address" (
        for /f "tokens=2" %%h in ('echo %%g') do echo %%h
        set catch=1
    )
)
