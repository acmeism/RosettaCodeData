RAII-class create Err {
    variable N E
    constructor {number {error 0.0}} {
	next
	namespace import ::tcl::mathfunc::* ::tcl::mathop::*
	variable N $number E [abs $error]
    }
    method p {} {
	return "$N \u00b1 $E"
    }

    method n {} { return $N }
    method e {} { return $E }

    method + e {
	if {[info object isa object $e]} {
	    Err return [+ $N [$e n]] [hypot $E [$e e]]
	} else {
	    Err return [+ $N $e] $E
	}
    }
    method - e {
	if {[info object isa object $e]} {
	    Err return [- $N [$e n]] [hypot $E [$e e]]
	} else {
	    Err return [- $N $e] $E
	}
    }
    method * e {
	if {[info object isa object $e]} {
	    set f [* $n [$E n]]
	    Err return $f [expr {hypot($E*$f/$N, [$e e]*$f/[$e n])}]
	} else {
	    Err return [* $N $e] [abs [* $E $e]]
	}
    }
    method / e {
	if {[info object isa object $e]} {
	    set f [/ $n [$E n]]
	    Err return $f [expr {hypot($E*$f/$N, [$e e]*$f/[$e n])}]
	} else {
	    Err return [/ $N $e] [abs [/ $E $e]]
	}
    }
    method ** c {
	set f [** $N $c]
	Err return $f [abs [* $f $c [/ $E $N]]]
    }

    export + - * / **
}
