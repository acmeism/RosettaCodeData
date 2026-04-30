@echo off
setlocal enableextensions
pushd "%temp%"
<nul set/p"=Rosetta code" > "Rosetta code"
certutil -hashfile "Rosetta code" SHA256
del "Rosetta code"
pause
