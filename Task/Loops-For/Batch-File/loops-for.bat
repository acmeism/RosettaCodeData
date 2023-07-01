@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

for /l %%i in (1,1,5) do (
    SET line=
    for /l %%j in (1,1,%%i) do (
        SET line=!line!*
    )
    ECHO !line!
)

ENDLOCAL
