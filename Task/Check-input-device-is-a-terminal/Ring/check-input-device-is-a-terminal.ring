# Project  : Check input device is a terminal

load "stdlib.ring"

if isWindows()
   write("mycmd.bat","
   @echo off
    timeout 1 2>nul >nul
    if errorlevel 1 (
       echo input redirected
        ) else (
       echo input is console
       )
       ")
    see SystemCmd("mycmd.bat")
ok
