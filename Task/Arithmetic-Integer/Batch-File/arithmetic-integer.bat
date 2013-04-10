@echo off
set /P A=Enter 1st Number :
set /P B=Enter 2nd Number :
set D=%A% + %B% & call :printC
set D=%A% - %B% & call :printC
set D=%A% * %B% & call :printC
set D=%A% / %B% & call :printC & rem truncates toward 0
set D=%A% %% %B% & call :printC & rem matches sign of 1st operand
exit /b

:printC
set /A C=%D%
echo %D% = %C%
