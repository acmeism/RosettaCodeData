:: The Twelve Days of Christmas
:: Batch File Implementation

@echo off

::Pseudo-array for Days
set "day1=First"
set "day2=Second"
set "day3=Third"
set "day4=Fourth"
set "day5=Fifth"
set "day6=Sixth"
set "day7=Seventh"
set "day8=Eighth"
set "day9=Nineth"
set "day10=Tenth"
set "day11=Eleventh"
set "day12=Twelveth"

::Pseudo-array for Gifts
set "gift12=Twelve drummers drumming"
set "gift11=Eleven pipers piping"
set "gift10=Ten loards a-leaping"
set "gift9=Nine ladies dancing"
set "gift8=Eight maids a-milking"
set "gift7=Seven swans a-swimming"
set "gift6=Six geese a-laying"
set "gift5=Five golden rings"
set "gift4=Four calling birds"
set "gift3=Three french hens"
set "gift2=Two turtle doves"
set "gift1=A partridge in a pear tree"

::Display It!
setlocal enabledelayedexpansion
for /l %%i in (1,1,12) do (
	echo On the !day%%i! day of Christmas
        echo My true love gave to me:

	for /l %%j in (%%i,-1,1) do (
		if %%j equ 1 (
			if %%i neq 1 <nul set /p ".=And "
			echo !gift1!.
		) else (
			echo !gift%%j!,
		)
	)
	echo(
)
exit /b
