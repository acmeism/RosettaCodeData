@echo off
setlocal enabledelayedexpansion

	%==Sample list==%
set "data=foo, bar, baz, quux, quuux, quuuux, bazola, ztesch, foo, bar, thud, grunt"
set "data=%data% foo, bar, bletch, foo, bar, fum, fred, jim, sheila, barney, flarp, zxc"
set "data=%data% spqr, wombat, shme, foo, bar, baz, bongo, spam, eggs, snork, foo, bar"
set "data=%data% zot, blarg, wibble, toto, titi, tata, tutu, pippo, pluto, paperino, aap"
set "data=%data% noot, mies, oogle, foogle, boogle, zork, gork, bork"

	%==Sample "needles" [whitespace is the delimiter]==%
set "needles=foo bar baz jim bong"

	%==Counting and Seperating each Data==%
set datalen=0
for %%. in (!data!) do (
	set /a datalen+=1
	set data!datalen!=%%.
)
	%==Do the search==%
for %%A in (!needles!) do (
	set "first="
	set "last="
	set "found=0"
	for /l %%B in (1,1,%datalen%) do (
		if "!data%%B!" == "%%A" (
			set /a found+=1
			if !found! equ 1 set first=%%B
			set last=%%B
		)
	)

	if !found! equ 0 echo."%%A": Not found.
	if !found! equ 1 echo."%%A": Found once in index [!first!].
	if !found! gtr 1 echo."%%A": Found !found! times. First instance:[!first!] Last instance:[!last!].

)
	%==We are done==%
echo.
pause
