-- doors.ex
include std/console.e
sequence doors
doors = repeat( 0, 100 ) -- 1 to 100, initialised to false

for pass = 1 to 100 do
	for door = pass to 100 by pass do
		--printf( 1, "%d", doors[door] )
		--printf( 1, "%d", not doors[door] )
		doors[door] = not doors[door]
	end for
end for

sequence oc

for i = 1 to 100 do
	if doors[i] then
		oc = "open"
	else
		oc = "closed"
	end if
 	printf( 1, "door %d is %s\n", { i, oc } )
end for
