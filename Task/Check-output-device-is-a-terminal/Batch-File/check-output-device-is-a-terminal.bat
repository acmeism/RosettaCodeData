@echo off
setlocal enableextensions enabledelayedexpansion
for /f %%a in ('copy /z "%~f0" nul') do set "CR=%%a"
(set check=^>con set/p"=Stdout is redirected^!CR^!"^&set/p"=Stdout is not redirected")
<nul (%check%)
>con echo:
<nul 1>&2 (%check:out=err%)
