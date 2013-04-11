CHOICE /m "Press Y for yes or N for no."
IF ERRORLEVEL 2 GOTO No
IF ERRORLEVEL 1 GOTO Yes
ECHO Cancel
GOTO End
:Yes
ECHO Your answer was YES.
GOTO End
:No
ECHO Your answer was NO.
:End
