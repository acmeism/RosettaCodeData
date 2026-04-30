@echo off
setlocal
set /p list=||goto :eof
set "list=%list:[=%"
set "list=%list:]=%"
set newlist=
setlocal enabledelayedexpansion
for %%i in (%list%) do set "newlist=!newlist!, %%i"
echo:[%newlist:~2%]
