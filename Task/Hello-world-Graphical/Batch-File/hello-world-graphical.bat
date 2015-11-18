@echo off

::Output to message box [Does not work in Window 7 and later]
msg * "Goodbye, World!" 2>nul

::Using MSHTA.EXE Hack::
@mshta javascript:alert("Goodbye, World!");code(close());
@mshta vbscript:Execute("msgbox(""Goodbye, World!""):code close")
pause
