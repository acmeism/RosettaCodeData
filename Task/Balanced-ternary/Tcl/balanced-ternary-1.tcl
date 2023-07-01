package require Tcl 8.5

proc bt-int b {
    set n 0
    foreach c [split $b ""] {
	set n [expr {$n * 3}]
	switch -- $c {
	    + { incr n 1  }
	    - { incr n -1 }
	}
    }
    return $n
}
proc int-bt n {
    if {$n == 0} {
	return "0"
    }
    while {$n != 0} {
	lappend result [lindex {0 + -} [expr {$n % 3}]]
	set n [expr {$n / 3 + ($n%3 == 2)}]
    }
    return [join [lreverse $result] ""]
}

proc bt-neg b {
    string map {+ - - +} $b
}
proc bt-sub {a b} {
    bt-add $a [bt-neg $b]
}
proc bt-add-digits {a b c} {
    if {$a eq ""} {set a 0}
    if {$b eq ""} {set b 0}
    if {$a ne 0} {append a 1}
    if {$b ne 0} {append b 1}
    lindex {{0 -1} {+ -1} {- 0} {0 0} {+ 0} {- 1} {0 1}} [expr {$a+$b+$c+3}]
}
proc bt-add {a b} {
    set c 0
    set result {}
    foreach ca [lreverse [split $a ""]] cb [lreverse [split $b ""]] {
	lassign [bt-add-digits $ca $cb $c] d c
	lappend result $d
    }
    if {$c ne "0"} {lappend result [lindex {0 + -} $c]}
    if {![llength $result]} {return "0"}
    string trimleft [join [lreverse $result] ""] 0
}
proc bt-mul {a b} {
    if {$a eq "0" || $a eq "" || $b eq "0"} {return "0"}
    set sub [bt-mul [string range $a 0 end-1] $b]0
    switch -- [string index $a end] {
	0 { return $sub }
	+ { return [bt-add $sub $b] }
	- { return [bt-sub $sub $b] }
    }
}
