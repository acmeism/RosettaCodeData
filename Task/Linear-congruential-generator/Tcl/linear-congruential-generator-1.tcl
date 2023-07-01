package require Tcl 8.6

# General form of a linear-congruential RNG
oo::class create LCRNG {
    variable seed A B C D
    constructor {init a b c d} {
	if {$init < 1} {set init [clock clicks]}
	variable seed $init A $a B $b C $c D $d
    }
    method rand {} {
	set seed [expr {($A * $seed + $B) % $C}]
	return [expr {$seed / $D}]
    }
    method srand x {
	set seed $x
    }
}
# Subclass to introduce constants
oo::class create BSDRNG {
    superclass LCRNG
    constructor {{initialSeed -1}} {
	next $initialSeed 1103515245 12345 [expr {2**31}] 1
    }
}
oo::class create MSRNG {
    superclass LCRNG
    constructor {{initialSeed -1}} {
	next $initialSeed 214013 2531011 [expr {2**31}] [expr {2**16}]
    }
}
