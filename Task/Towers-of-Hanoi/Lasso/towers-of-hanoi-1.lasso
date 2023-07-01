#!/usr/bin/lasso9

define towermove(
	disks::integer,
	a,b,c
) => {
	if(#disks > 0) => {
		towermove(#disks - 1, #a, #c, #b )
		stdoutnl("Move disk from " + #a + " to " + #c)
		towermove(#disks - 1, #b, #a, #c )
	}
}

towermove((integer($argv -> second || 3)), "A", "B", "C")
