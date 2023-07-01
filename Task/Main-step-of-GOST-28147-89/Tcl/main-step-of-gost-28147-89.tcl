namespace eval ::GOST {
    proc tcl::mathfunc::k {a b} {
	variable ::GOST::replacementTable
	lindex $replacementTable $a $b
    }

    proc mainStep {textBlock idx key} {
	variable replacementTable
	lassign [lindex $textBlock $idx] N0 N1
	set S [expr {($N0 + $key) & 0xFFFFFFFF}]
	set newS 0
	for {set i 0} {$i < 4} {incr i} {
	    set cell [expr {$S >> ($i * 8) & 0xFF}]
	    incr newS [expr {
		(k($i*2, $cell%15) + k($i*2+1, $cell/16) * 16) << ($i * 8)
	    }]
	}
	set S [expr {((($newS << 11) + ($newS >> 21)) & 0xFFFFFFFF) ^ $N1}]
	lset textBlock $idx [list $S $N0]
	return $textBlock
    }
}
