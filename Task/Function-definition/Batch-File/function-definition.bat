@ECHO OFF
SET /A result = 0
CALL :multiply 2 3
ECHO %result%
GOTO :eof

:multiply
    SET /A result = %1 * %2
    GOTO :eof

:eof
