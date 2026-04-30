@if defined doSort goto sort
@echo off
setlocal enabledelayedexpansion
(set lf=^

)
set doSort=1
set nums=!lf!765!lf!1232!lf!457615!lf!29681!lf!20932
echo Before:
set nums | more +1
echo After:
for /f %%i in ('cmd /q /v:on /e:on /d /c "%~f0" ^| sort') do echo/%%i
goto:eof
:sort
for /f %%i in ("!nums!") do (
    REM 12 leading spaces:
    set "Z=            %%i"
    REM take last 12 digits:
    echo !Z:~-12!
)
