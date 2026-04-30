@echo off
setlocal enableextensions enabledelayedexpansion
(set LF=^

)
for /f %%a in ('copy /Z "%~dpf0" nul') do set "CR=%%a"
::don't ignore blank lines
set buffer=
for /f tokens^=1*^ delims^=]^ eol^= %%a in ('type %1 ^| find /n /v ""') do set "buffer=!buffer!%%b!CR!!LF!"
