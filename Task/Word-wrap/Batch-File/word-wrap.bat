@echo off

set "input=Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur!"
rem call the function (the second parameter is the line width)
call :wrap "%input%" 40
echo(
call :wrap "%input%" 70
pause>nul
exit /b 0

:: The procedure
:wrap
set "line="
set "tmp_str=%~1"
set /a "width=%2", "width-=1"

:proc_loop
rem check if we are done already
if "%tmp_str%"=="" (
    setlocal enabledelayedexpansion
    if defined line echo(!line!
    endlocal & goto :EOF
)

rem not yet done, so take a word and process it
for /f "tokens=1,* delims= " %%A in ("%tmp_str%") do (
    set "word=%%A"
    set "tmp_str=%%B"

    setlocal enabledelayedexpansion
    if "!line!"=="" (set "testline=!word!") else (set "testline=!line! !word!")
    if "!testline:~%width%,1!" == "" (
        set "line=!testline!"
    ) else (
        echo(!line!
        set "line=!word!"
    )
)
endlocal & set "line=%line%"
goto proc_loop
