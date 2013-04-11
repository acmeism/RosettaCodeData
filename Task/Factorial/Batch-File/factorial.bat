@echo off
set /p x=
set /a fs=%x%-1
set y=%x%
FOR /L %%a IN (%fs%, -1, 1) DO SET /a y*=%%a
if %x% EQU 0 set y=1
echo %y%
pause
exit
