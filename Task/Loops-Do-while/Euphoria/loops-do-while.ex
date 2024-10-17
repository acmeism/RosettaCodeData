include std/console.e
include std/math.e

atom x = 0

loop do
	x += 1
	?x
	until(mod(x,6)) = 0
end loop

if getc(0) then end if
