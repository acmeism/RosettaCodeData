#!/usr/bin/env  tclsh

# 100 doors

proc seq { m n } {
    set r {}
    for {set i $m} {$i <= $n} {incr i} {
	    lappend r $i
    }
    return $r
}

proc toggle {val a b} {
    # expr has ternary operators
    return  [expr {
		        ${val} == ${a}? ${b} :
		        ${val} == ${b}? ${a} :
		        [error "bad value: ${val}"]
	        }]
}

proc multiples {n max} {
    set ret {}
    set x $n

    # maximum multiple
    set mid  [expr $max / 2]

    if {$x>=$mid  &&  $x<$max} { return $x }

    # calculate multiples
    if {[expr $x <= $mid]} {
	    for {set i 1} {$i <= $max } {incr i} {

	        set x [expr $i * $n]

   	        if {$x > $max} { break }
	
	        lappend ret $x
	    }
    }

    return $ret
}

# states
array set state {
    open    "open"
    closed  "closed"
    unknown "?"
}

# ==============================
# start program

# 100 doors
variable MAX  100

variable mid  [expr int($MAX / 2)]

variable Seq_100  [seq 1 $MAX]

# initialize doors closed
foreach n $Seq_100 {
    set door($n) $state(closed)
}

# do for 1 .. 100
foreach m $Seq_100 {

    set mults [multiples $m $MAX]

    foreach d $mults {
	    set door($d) [toggle $door($d) $state(open) $state(closed)]
    }
}

# output
foreach n $Seq_100 {
    if { $door($n) eq $state(open) } {
	    puts stdout "$n: $door($n)"
    }
}

# end
