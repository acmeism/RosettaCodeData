@echo off
if "%2" equ "" goto fail
setlocal enabledelayedexpansion
set char=%1
set num=%2
for /l %%i in (1,1,%num%) do set res=!res!%char%
echo %res%
:fail
