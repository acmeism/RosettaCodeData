@echo off
call :filesize input.txt
echo Size of file input.txt: %res%
call :filesize \input.txt
echo Size of file \input.txt: %res%
goto:eof

:filesize
2>nul (
for %%i in ("%~1") do set /a res=%%~zi
) || set /a res=-1
goto:eof
