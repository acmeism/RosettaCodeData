@echo off

::true
set "a=x"
::false
set "b="

if defined a (
	echo a is true
) else (
	echo a is false
)
if defined b (
	echo b is true
) else (
	echo b is false
)

pause>nul
