proc init {initialConfiguration} {
    global grid max filled
    set max 1
    set y 0
    foreach row [split [string trim $initialConfiguration "\n"] "\n"] {
	set x 0
	set rowcontents {}
	foreach cell $row {
	    if {![string is integer -strict $cell]} {set cell -1}
	    lappend rowcontents $cell
	    set max [expr {max($max, $cell)}]
	    if {$cell > 0} {
		dict set filled $cell [list $y $x]
	    }
	    incr x
	}
	lappend grid $rowcontents
	incr y
    }
}

proc findseps {} {
    global max filled
    set result {}
    for {set i 1} {$i < $max-1} {incr i} {
	if {[dict exists $filled $i]} {
	    for {set j [expr {$i+1}]} {$j <= $max} {incr j} {
		if {[dict exists $filled $j]} {
		    if {$j-$i > 1} {
			lappend result [list $i $j [expr {$j-$i}]]
		    }
		    break
		}
	    }
	}
    }
    return [lsort -integer -index 2 $result]
}

proc makepaths {sep} {
    global grid filled
    lassign $sep from to len
    lassign [dict get $filled $from] y x
    set result {}
    foreach {dx dy} {-1 -1  -1 0  -1 1  0 -1  0 1  1 -1  1 0  1 1} {
	discover [expr {$x+$dx}] [expr {$y+$dy}] [expr {$from+1}] $to \
	    [list [list $from $x $y]] $grid
    }
    return $result
}
proc discover {x y n limit path model} {
    global filled
    # Check for illegal
    if {[lindex $model $y $x] != 0} return
    upvar 1 result result
    lassign [dict get $filled $limit] ly lx
    # Special case
    if {$n == $limit-1} {
	if {abs($x-$lx)<=1 && abs($y-$ly)<=1 && !($lx==$x && $ly==$y)} {
	    lappend result [lappend path [list $n $x $y] [list $limit $lx $ly]]
	}
	return
    }
    # Check for impossible
    if {abs($x-$lx) > $limit-$n || abs($y-$ly) > $limit-$n} return
    # Recursive search
    lappend path [list $n $x $y]
    lset model $y $x $n
    incr n
    foreach {dx dy} {-1 -1  -1 0  -1 1  0 -1  0 1  1 -1  1 0  1 1} {
	discover [expr {$x+$dx}] [expr {$y+$dy}] $n $limit $path $model
    }
}

proc applypath {path} {
    global grid filled
    puts "Found unique path for [lindex $path 0 0] -> [lindex $path end 0]"
    foreach cell [lrange $path 1 end-1] {
	lassign $cell n x y
	lset grid $y $x $n
	dict set filled $n [list $y $x]
    }
}

proc printgrid {} {
    global grid max
    foreach row $grid {
	foreach cell $row {
	    puts -nonewline [format " %*s" [string length $max] [expr {
		$cell==-1 ? "." : $cell
	    }]]
	}
	puts ""
    }
}

proc solveHidato {initialConfiguration} {
    init $initialConfiguration
    set limit [llength [findseps]]
    while {[llength [set seps [findseps]]] && [incr limit -1]>=0} {
	foreach sep $seps {
	    if {[llength [set paths [makepaths $sep]]] == 1} {
		applypath [lindex $paths 0]
		break
	    }
	}
    }
    puts ""
    printgrid
}
