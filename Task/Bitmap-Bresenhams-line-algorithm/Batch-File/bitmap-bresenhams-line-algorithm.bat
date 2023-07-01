@echo off
setlocal enabledelayedexpansion

set width=87
set height=51

mode %width%,%height%

set "grid="
set /a resolution=height*width
for /l %%i in (1,1,%resolution%) do (
	set "grid=!grid! "
)
call :line 1 1 5 5
call :line 9 30 60 7
call :line 9 30 60 50
call :line 52 50 32 1
echo:%grid%
pause>nul
exit

:line
	set x1=%1
	set y1=%2
	set x2=%3
	set y2=%4

	set /a dx=x2-x1
	set /a dy=y2-y1

	::Clipping done to avoid overflow

	if %dx% neq 0 set /a o=y1 - ( x1 * dy / dx )
	if %x1% leq %x2% (
		if %x1% geq %width% goto :eof
		if %x2% lss 0 goto :eof

		if %x1% lss 0 (
			if %dx% neq 0 set y1=%o%
			set x1=0
		)
		if %x2% geq %width% (
			set /a x2= width - 1
			if %dx% neq 0 set /a "y2= x2 * dy / dx + o"
		)
	) else (
		if %x2% geq %width% goto :eof
		if %x1% lss 0 goto :eof

		if %x2% lss 0 (
			if %dx% neq 0 set y2=%o%
			set x2=0
		)
		if %x1% geq %width% (
			set /a x1=width - 1
			if %dx% neq 0 set /a "y1= x1 * dy / dx + o"
		)
	)
	if %y1% leq %y2% (
		if %y1% geq %height% goto :eof
		if %y2% lss 0 goto :eof

		if %y1% lss 0 (
			set y1=0
			if %dx% neq 0 set /a x1= - o * dx /dy
		)
		if %y2% geq %height% (
			set /a y2=height-1
			if %dx% neq 0 set /a "x2= (y2 - o) * dx /dy"
		)
	) else (
		if %y2% geq %height% goto :eof
		if %y1% lss 0 goto :eof

		if %y2% lss 0 (
			set y2=0
			if %dx% neq 0 set /a "x2= - o * dx /dy"
		)
		if %y1% geq %height% (
			set /a y1=height-1
			if %dx% neq 0 set /a "x1= (y1 - o) * dx /dy"
		)
	)

	:: Start of Bresenham's algorithm

	set stepy=1
	set stepx=1

	set /a dx=x2-x1
	set /a dy=y2-y1

	if %dy% lss 0 set /a "dy=-dy","stepy=-1"
	if %dx% lss 0 set /a "dx=-dx","stepx=-1"

	set /a "dy <<= 1"
	set /a "dx <<= 1"

	if %dx% gtr %dy% (
		set /a "fraction=dy-(dx>>1)"
		set /a "cursor=y1*width + x1"
		for /l %%x in (%x1%,%stepx%,%x2%) do (
			set /a cursorP=cursor+1
			for /f "tokens=1-2" %%g in ("!cursor! !cursorP!") do set "grid=!grid:~0,%%g!Û!grid:~%%h!"
			if !fraction! geq 0 (
				set /a y1+=stepy
				set /a cursor+=stepy*width
				set /a fraction-=dx
			)
			set /a fraction+=dy
			set /a cursor+=stepx
		)
	) else (
		set /a "fraction=dx-(dy>>1)"
		set /a "cursor=y1*width + x1"
		for /l %%y in (%y1%,%stepy%,%y2%) do (
			set /a cursorP=cursor+1
			for /f "tokens=1-2" %%g in ("!cursor! !cursorP!") do set "grid=!grid:~0,%%g!Û!grid:~%%h!"
			if !fraction! geq 0 (
				set /a x1+=stepx
				set /a cursor+=stepx
				set /a fraction-=dy
			)
			set /a fraction+=dx
			set /a cursor+=width*stepy
		)
	)
	goto :eof
