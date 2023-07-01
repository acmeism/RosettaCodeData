@echo off
if %1@==@ (
    if exist notes.txt more notes.txt
    goto :eof
)
echo %date% %time%:>>notes.txt
echo 	%*>>notes.txt
