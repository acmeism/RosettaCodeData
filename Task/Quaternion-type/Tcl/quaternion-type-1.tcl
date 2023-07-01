package require TclOO

# Support class that provides C++-like RAII lifetimes
oo::class create RAII-support {
    constructor {} {
	upvar 1 { end } end
	lappend end [self]
	trace add variable end unset [namespace code {my destroy}]
    }
    destructor {
	catch {
	    upvar 1 { end } end
	    trace remove variable end unset [namespace code {my destroy}]
	}
    }
    method return {{level 1}} {
	incr level
	upvar 1 { end } end
	upvar $level { end } parent
	trace remove variable end unset [namespace code {my destroy}]
	lappend parent [self]
	trace add variable parent unset [namespace code {my destroy}]
	return -level $level [self]
    }
}

# Class of quaternions
oo::class create Q {
    superclass RAII-support
    variable R I J K
    constructor {{real 0} {i 0} {j 0} {k 0}} {
	next
	namespace import ::tcl::mathfunc::* ::tcl::mathop::*
	variable R [double $real] I [double $i] J [double $j] K [double $k]
    }
    self method return args {
	[my new {*}$args] return 2
    }

    method p {} {
	return "Q($R,$I,$J,$K)"
    }
    method values {} {
	list $R $I $J $K
    }

    method Norm {} {
	+ [* $R $R] [* $I $I] [* $J $J] [* $K $K]
    }

    method conjugate {} {
	Q return $R [- $I] [- $J] [- $K]
    }
    method norm {} {
	sqrt [my Norm]
    }
    method unit {} {
	set n [my norm]
	Q return [/ $R $n] [/ $I $n] [/ $J $n] [/ $K $n]
    }
    method reciprocal {} {
	set n2 [my Norm]
	Q return [/ $R $n2] [/ $I $n2] [/ $J $n2] [/ $K $n2]
    }
    method - {{q ""}} {
	if {[llength [info level 0]] == 2} {
	    Q return [- $R] [- $I] [- $J] [- $K]
	}
	[my + [$q -]] return
    }
    method + q {
	if {[info object isa object $q]} {
	    lassign [$q values] real i j k
	    Q return [+ $R $real] [+ $I $i] [+ $J $j] [+ $K $k]
	}
	Q return [+ $R [double $q]] $I $J $K
    }
    method * q {
	if {[info object isa object $q]} {
	    lassign [my values] a1 b1 c1 d1
	    lassign [$q values] a2 b2 c2 d2
	    Q return [expr {$a1*$a2 - $b1*$b2 - $c1*$c2 - $d1*$d2}] \
		[expr {$a1*$b2 + $b1*$a2 + $c1*$d2 - $d1*$c2}] \
		[expr {$a1*$c2 - $b1*$d2 + $c1*$a2 + $d1*$b2}] \
		[expr {$a1*$d2 + $b1*$c2 - $c1*$b2 + $d1*$a2}]
	}
	set f [double $q]
	Q return [* $R $f] [* $I $f] [* $J $f] [* $K $f]
    }
    method == q {
	expr {
	    [info object isa object $q]
	    && [info object isa typeof $q [self class]]
	    && [my values] eq [$q values]
	}
    }

    export - + * ==
}
