@echo off
@FOR /L %%i in (0,1,9) DO @CALL :REPEAT %%i
@echo That's it!
@FOR /L %%i in (0,1,9) DO @CALL :REPEAT %%i
@echo.
@echo And that!
@GOTO END

:REPEAT
@echo|set /p="*"
@GOTO:EOF

:END
