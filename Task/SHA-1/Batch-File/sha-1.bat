@echo off
setlocal enableextensions
set /p str=
pushd "%temp%"
<nul set/p"=%str%" > "%str%"
certutil -hashfile "%str%"
del "%str%"
pause
