@echo off
setlocal enableextensions
set "_t=%temp%\favicon.tmp"
::using certutil -encodehex undocumented param to encode as Base64
::https://www.dostips.com/forum/viewtopic.php?f=3&t=8521
1>&2 certutil -f -encodehex favicon.ico "%_t%" 1073741825 || goto:eof %= 0x40000000 | 0x1 =%
type "%_t%"
del "%_t%"
