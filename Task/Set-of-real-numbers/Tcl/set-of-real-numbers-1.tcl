package require Tcl 8.5

proc inRange {x range} {
    lassign $range a aClosed b bClosed
    expr {($aClosed ? $a<=$x : $a<$x) && ($bClosed ? $x<=$b : $x<$b)}
}
proc normalize {A} {
    set A [lsort -index 0 -real [lsort -index 1 -integer -decreasing $A]]
    for {set i 0} {$i < [llength $A]} {incr i} {
	lassign [lindex $A $i] a aClosed b bClosed
	if {$b < $a || ($a == $b && !($aClosed && $bClosed))} {
	    set A [lreplace $A $i $i]
	    incr i -1
	}
    }
    for {set i 0} {$i < [llength $A]} {incr i} {
	for {set j [expr {$i+1}]} {$j < [llength $A]} {incr j} {
	    set R [lindex $A $i]
	    lassign [lindex $A $j] a aClosed b bClosed
	    if {[inRange $a $R]} {
		if {![inRange $b $R]} {
		    lset A $i 2 $b
		    lset A $i 3 $bClosed
		}
		set A [lreplace $A $j $j]
		incr j -1
	    }
	}
    }
    return $A
}

proc realset {args} {
    set RE {^\s*([\[(])\s*([-\d.e]+|-inf)\s*,\s*([-\d.e]+|inf)\s*([\])])\s*$}
    set result {}
    foreach s $args {
	if {
	    [regexp $RE $s --> left a b right] &&
	    [string is double $a] && [string is double $b]
	} then {
	    lappend result [list \
		$a [expr {$left eq "\["}] $b [expr {$right eq "\]"}]]
	} else {
	    error "bad range descriptor"
	}
    }
    return $result
}
proc elementOf {x A} {
    foreach range $A {
	if {[inRange $x $range]} {return 1}
    }
    return 0
}
proc union {A B} {
    return [normalize [concat $A $B]]
}
proc intersection {A B} {
    set B [normalize $B]
    set C {}
    foreach RA [normalize $A] {
	lassign $RA Aa AaClosed Ab AbClosed
	foreach RB $B {
	    lassign $RB Ba BaClosed Bb BbClosed
	    if {$Aa > $Bb || $Ba > $Ab} continue
	    set RC {}
	    lappend RC [expr {max($Aa,$Ba)}]
	    if {$Aa==$Ba} {
		lappend RC [expr {min($AaClosed,$BaClosed)}]
	    } else {
		lappend RC [expr {$Aa>$Ba ? $AaClosed : $BaClosed}]
	    }
	    lappend RC [expr {min($Ab,$Bb)}]
	    if {$Ab==$Bb} {
		lappend RC [expr {min($AbClosed,$BbClosed)}]
	    } else {
		lappend RC [expr {$Ab<$Bb ? $AbClosed : $BbClosed}]
	    }
	    lappend C $RC
	}
    }
    return [normalize $C]
}
proc difference {A B} {
    set C {}
    set B [normalize $B]
    foreach arange [normalize $A] {
	if {[isEmpty [intersection [list $arange] $B]]} {
	    lappend C $arange
	    continue
	}
	lassign $arange Aa AaClosed Ab AbClosed
	foreach brange $B {
	    lassign $brange Ba BaClosed Bb BbClosed
	    if {$Bb < $Aa || ($Bb==$Aa && !($AaClosed && $BbClosed))} {
		continue
	    }
	    if {$Ab < $Ba || ($Ab==$Ba && !($BaClosed && $AbClosed))} {
		lappend C [list $Aa $AaClosed $Ab $AbClosed]
		unset arange
		break
	    }
	    if {$Aa==$Bb} {
		set AaClosed 0
		continue
	    } elseif {$Ab==$Ba} {
		set AbClosed 0
		lappend C [list $Aa $AaClosed $Ab $AbClosed]
		unset arange
		continue
	    }
	    if {$Aa<$Ba} {
		lappend C [list $Aa $AaClosed $Ba [expr {!$BaClosed}]]
		if {$Ab>$Bb} {
		    set Aa $Bb
		    set AaClosed [expr {!$BbClosed}]
		} else {
		    unset arange
		    break
		}
	    } elseif {$Aa==$Ba} {
		lappend C [list $Aa $AaClosed $Ba [expr {!$BaClosed}]]
		set Aa $Bb
		set AaClosed [expr {!$BbClosed}]
	    } else {
		set Aa $Bb
		set AaClosed [expr {!$BbClosed}]
	    }
	}
	if {[info exist arange]} {
	    lappend C [list $Aa $AaClosed $Ab $AbClosed]
	}
    }
    return [normalize $C]
}
proc isEmpty A {
    expr {![llength [normalize $A]]}
}
proc length A {
    set len 0.0
    foreach range [normalize $A] {
	lassign $range a _ b _
	set len [expr {$len + ($b-$a)}]
    }
    return $len
}
