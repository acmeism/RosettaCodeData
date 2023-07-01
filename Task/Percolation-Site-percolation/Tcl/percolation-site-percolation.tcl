package require Tcl 8.6

oo::class create SitePercolation {
    variable cells w h
    constructor {width height probability} {
	set w $width
	set h $height
	for {set cells {}} {[llength $cells] < $h} {lappend cells $row} {
	    for {set row {}} {[llength $row] < $w} {lappend row $cell} {
		set cell [expr {rand() < $probability}]
	    }
	}
    }
    method print {out} {
	array set map {0 "#" 1 " " -1 .}
	puts "+[string repeat . $w]+"
	foreach row $cells {
	    set s "|"
	    foreach cell $row {
		append s $map($cell)
	    }
	    puts [append s "|"]
	}
	set outline [lrepeat $w "-"]
	foreach index $out {
	    lset outline $index "."
	}
	puts "+[join $outline {}]+"
    }
    method percolate {} {
	for {set work {}; set i 0} {$i < $w} {incr i} {
	    if {[lindex $cells 0 $i]} {lappend work 0 $i}
	}
	try {
	    my Fill $work
	    return {}
	} trap PERCOLATED x {
	    return [list $x]
	}
    }
    method Fill {queue} {
	while {[llength $queue]} {
	    set queue [lassign $queue y x]
	    if {$y >= $h} {throw PERCOLATED $x}
	    if {$y < 0 || $x < 0 || $x >= $w} continue
	    if {[lindex $cells $y $x]<1} continue
	    lset cells $y $x -1
	    lappend queue [expr {$y+1}] $x [expr {$y-1}] $x
	    lappend queue $y [expr {$x-1}] $y [expr {$x+1}]
	}
    }
}

# Demonstrate one run
puts "Sample percolation, 15x15 p=0.6"
SitePercolation create bp 15 15 0.6
bp print [bp percolate]
bp destroy
puts ""

# Collect statistics
apply {{} {
    puts "Percentage of tries that percolate, varying p"
    set tries 100
    for {set pint 0} {$pint <= 10} {incr pint} {
	set p [expr {$pint * 0.1}]
	set tot 0
	for {set i 0} {$i < $tries} {incr i} {
	    set bp [SitePercolation new 15 15 $p]
	    if {[$bp percolate] ne ""} {
		incr tot
	    }
	    $bp destroy
	}
	puts [format "p=%.2f: %2.1f%%" $p [expr {$tot*100./$tries}]]
    }
}}
