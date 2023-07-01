package require Tcl 8.6

# Structure the bond percolation system as a class
oo::class create BondPercolation {
    variable hwall vwall cells M N
    constructor {width height probability} {
	set M $height
	set N $width
	for {set i 0} {$i <= $height} {incr i} {
	    for {set j 0;set walls {}} {$j < $width} {incr j} {
		lappend walls [expr {rand() < $probability}]
	    }
	    lappend hwall $walls
	}
	for {set i 0} {$i <= $height} {incr i} {
	    for {set j 0;set walls {}} {$j <= $width} {incr j} {
		lappend walls [expr {$j==0 || $j==$width || rand() < $probability}]
	    }
	    lappend vwall $walls
	}
	set cells [lrepeat $height [lrepeat $width 0]]
    }

    method print {{percolated ""}} {
	set nw [string length $M]
	set grid $cells
	if {$percolated ne ""} {
	    lappend grid [lrepeat $N 0]
	    lset grid end $percolated 1
	}
	foreach hws $hwall vws [lrange $vwall 0 end-1] r $grid {
	    incr row
	    puts -nonewline [string repeat " " [expr {$nw+2}]]
	    foreach w $hws {
		puts -nonewline [if {$w} {subst "+-"} {subst "+ "}]
	    }
	    puts "+"
	    puts -nonewline [format "%-*s" [expr {$nw+2}] [expr {
		$row>$M ? $percolated eq "" ? " " : ">" : "$row)"
	    }]]
	    foreach v $vws c $r {
		puts -nonewline [if {$v==1} {subst "|"} {subst " "}]
		puts -nonewline [if {$c==1} {subst "#"} {subst " "}]
	    }
	    puts ""
	}
    }

    method percolate {} {
	try {
	    for {set i 0} {$i < $N} {incr i} {
		if {![lindex $hwall 0 $i]} {
		    my FloodFill $i 0
		}
	    }
	    return ""
	} trap PERCOLATED n {
	    return $n
	}
    }
    method FloodFill {x y} {
	# fill cell
	lset cells $y $x 1
	# bottom
	if {![lindex $hwall [expr {$y+1}] $x]} {
	    if {$y == $N-1} {
		# THE bottom
		throw PERCOLATED $x
	    }
	    if {$y < $N-1 && ![lindex $cells [expr {$y+1}] $x]} {
		my FloodFill $x [expr {$y+1}]
	    }
	}
	# left
	if {![lindex $vwall $y $x] && ![lindex $cells $y [expr {$x-1}]]} {
	    my FloodFill [expr {$x-1}] $y
	}
	# right
	if {![lindex $vwall $y [expr {$x+1}]] && ![lindex $cells $y [expr {$x+1}]]} {
	    my FloodFill [expr {$x+1}] $y
	}
	# top
	if {$y>0 && ![lindex $hwall $y $x] && ![lindex $cells [expr {$y-1}] $x]} {
	    my FloodFill $x [expr {$y-1}]
	}
    }
}

# Demonstrate one run
puts "Sample percolation, 10x10 p=0.5"
BondPercolation create bp 10 10 0.5
bp print [bp percolate]
bp destroy
puts ""

# Collect some aggregate statistics
apply {{} {
    puts "Percentage of tries that percolate, varying p"
    set tries 100
    for {set pint 0} {$pint <= 10} {incr pint} {
	set p [expr {$pint * 0.1}]
	set tot 0
	for {set i 0} {$i < $tries} {incr i} {
	    set bp [BondPercolation new 10 10 $p]
	    if {[$bp percolate] ne ""} {
		incr tot
	    }
	    $bp destroy
	}
	puts [format "p=%.2f: %2.1f%%" $p [expr {$tot*100./$tries}]]
    }
}}
