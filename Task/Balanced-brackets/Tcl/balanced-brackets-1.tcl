proc generate {n} {
    if {!$n} return
    set l [lrepeat $n "\[" "\]"]
    set len [llength $l]
    while {$len} {
	set tmp [lindex $l [set i [expr {int($len * rand())}]]]
	lset l $i [lindex $l [incr len -1]]
	lset l $len $tmp
    }
    return [join $l ""]
}

proc balanced s {
    set n 0
    foreach c [split $s ""] {
	# Everything unmatched is ignored, which is what we want
	switch -exact -- $c {
	    "\[" {incr n}
	    "\]" {if {[incr n -1] < 0} {return false}}
	}
    }
    expr {!$n}
}

for {set i 0} {$i < 15} {incr i} {
    set s [generate $i]
    puts "\"$s\"\t-> [expr {[balanced $s] ? {OK} : {NOT OK}}]"
}
