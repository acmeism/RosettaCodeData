package require Tcl 8.6

oo::class create ISAAC {
    variable aa bb cc mm randrsl randcnt

    constructor {seed} {
	namespace eval tcl {
	    namespace eval mathfunc {
		proc mm {idx} {
		    upvar 1 mm list
		    lindex $list [expr {$idx % [llength $list]}]
		}
		proc clamp {value} {
		    expr {$value & 0xFFFFFFFF}
		}
	    }
	}
	proc mix1 {i v} {
	    upvar 1 a a
	    lset a $i [expr {clamp([lindex $a $i] ^ $v)}]
	    lset a [set idx [expr {($i+3)%8}]] \
		[expr {clamp([lindex $a $idx] + [lindex $a $i])}]
	    lset a [set idx [expr {($i+1)%8}]] \
		[expr {clamp([lindex $a $idx] + [lindex $a [expr {($i+2)%8}]])}]
	}

	binary scan $seed[string repeat \u0000 256] c256 randrsl
	set mm [lrepeat 256 0]
	set randcnt [set aa [set bb [set cc 0]]]

	set a [lrepeat 8 0x9e3779b9]
	foreach i {1 2 3 4} {
	    mix1 0 [expr {[lindex $a 1] << 11}]
	    mix1 1 [expr {[lindex $a 2] >> 2}]
	    mix1 2 [expr {[lindex $a 3] << 8}]
	    mix1 3 [expr {[lindex $a 4] >> 16}]
	    mix1 4 [expr {[lindex $a 5] << 10}]
	    mix1 5 [expr {[lindex $a 6] >> 4}]
	    mix1 6 [expr {[lindex $a 7] << 8}]
	    mix1 7 [expr {[lindex $a 0] >> 9}]
	}
	for {set i 0} {$i < 256} {incr i 8} {
	    set a [lmap av $a bv [lrange $randrsl $i [expr {$i+7}]] {
		expr {clamp($av + $bv)}
	    }]
	    mix1 0 [expr {[lindex $a 1] << 11}]
	    mix1 1 [expr {[lindex $a 2] >> 2}]
	    mix1 2 [expr {[lindex $a 3] << 8}]
	    mix1 3 [expr {[lindex $a 4] >> 16}]
	    mix1 4 [expr {[lindex $a 5] << 10}]
	    mix1 5 [expr {[lindex $a 6] >> 4}]
	    mix1 6 [expr {[lindex $a 7] << 8}]
	    mix1 7 [expr {[lindex $a 0] >> 9}]
	    for {set j 0} {$j < 8} {incr j} {
		lset mm [expr {$i+$j}] [lindex $a $j]
	    }
	}
	for {set i 0} {$i < 256} {incr i 8} {
	    set a [lmap av $a bv [lrange $mm $i [expr {$i+7}]] {
		expr {clamp($av + $bv)}
	    }]
	    mix1 0 [expr {[lindex $a 1] << 11}]
	    mix1 1 [expr {[lindex $a 2] >> 2}]
	    mix1 2 [expr {[lindex $a 3] << 8}]
	    mix1 3 [expr {[lindex $a 4] >> 16}]
	    mix1 4 [expr {[lindex $a 5] << 10}]
	    mix1 5 [expr {[lindex $a 6] >> 4}]
	    mix1 6 [expr {[lindex $a 7] << 8}]
	    mix1 7 [expr {[lindex $a 0] >> 9}]
	    for {set j 0} {$j < 8} {incr j} {
		lset mm [expr {$i+$j}] [lindex $a $j]
	    }
	}
	my Step
    }

    method Step {} {
	incr bb [incr cc]
	set i -1
	foreach x $mm {
	    set shift [lindex {13 -6 2 -16} [expr {[incr i] % 4}]]
	    set aa [expr {$aa ^ ($shift>0 ? $aa<<$shift : $aa>>-$shift)}]
	    set aa [expr {clamp($aa + mm($i+128))}]
	    set y [expr {clamp(mm($x>>2) + $aa + $bb)}]
	    lset mm $i $y
	    set bb [expr {clamp(mm($y>>10) + $x)}]
	    lset randrsl $i $bb
	}
    }

    method random {} {
	set r [lindex $randrsl $randcnt]
	if {[incr randcnt] == 256} {
	    my Step
	    set randcnt 0
	}
	return $r
    }

    method RandA {} {
	expr {([my random] % 95) + 32}
    }
    method vernam {msg} {
	binary scan $msg c* b
	for {set i 0} {$i < [llength $b]} {incr i} {
	    lset b $i [expr {[lindex $b $i] & 255 ^ [my RandA]}]
	}
	return [binary encode hex [binary format c* $b]]
    }
}
