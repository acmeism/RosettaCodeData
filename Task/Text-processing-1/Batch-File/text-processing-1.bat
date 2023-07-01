@echo off
setlocal ENABLEDELAYEDEXPANSION
set maxrun=    0
set maxstart=
set maxend=
set notok=0
set inputfile=%1
for /F "tokens=1,*" %%i in (%inputfile%) do (
    set date=%%i
    call :processline %%j
)

echo\
echo max false: %maxrun%  from %maxstart% until %maxend%

goto :EOF

:processline
set sum=0000
set count=0
set hour=1
:loop
if "%1"=="" goto :result
set num=%1
if "%2"=="1" (
    if "%notok%" NEQ "0" (
        set notok=     !notok!
        if /I "!notok:~-5!" GTR "%maxrun%" (
            set maxrun=!notok:~-5!
            set maxstart=%nok0date% %nok0hour%
            set maxend=%nok1date% %nok1hour%
        )
        set notok=0
    )
    set /a sum+=%num:.=%
    set /a count+=1
) else (
    if "%notok%" EQU "0" (
        set nok0date=%date%
        set nok0hour=%hour%
    ) else (
        set nok1date=%date%
        set nok1hour=%hour%
    )
    set /a notok+=1
)
shift
shift
set /a hour+=1
goto :loop

:result
if "%count%"=="0" (
    set mean=0
) else (
    set /a mean=%sum%/%count%
)
if "%mean%"=="0" set mean=0000
if "%sum%"=="0" set sum=0000
set mean=%mean:~0,-3%.%mean:~-3%
set sum=%sum:~0,-3%.%sum:~-3%
set count=   %count%
set sum=    %sum%
set mean=    %mean%
echo Line: %date% Accept: %count:~-3%  tot: %sum:~-8%  avg: %mean:~-8%

goto :EOF
