@echo off
set /p i=Insert number:

::bitwise and
set /a "test1=%i%&1"

::divide last character by 2
set /a test2=%i:~-1%/2

::modulo
set /a test3=%i% %% 2

set test
pause>nul
