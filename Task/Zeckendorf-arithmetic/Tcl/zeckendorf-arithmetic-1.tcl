namespace eval zeckendorf {
    # Want to use alternate symbols? Change these
    variable zero "0"
    variable one "1"

    # Base operations: increment and decrement
    proc zincr var {
	upvar 1 $var a
	namespace upvar [namespace current] zero 0 one 1
	if {![regsub "$0$" $a $1$0 a]} {append a $1}
	while {[regsub "$0$1$1" $a "$1$0$0" a]
		|| [regsub "^$1$1" $a "$1$0$0" a]} {}
	regsub ".$" $a "" a
	return $a
    }
    proc zdecr var {
	upvar 1 $var a
	namespace upvar [namespace current] zero 0 one 1
	regsub "^$0+(.+)$" [subst [regsub "${1}($0*)$" $a "$0\[
		string repeat {$1$0} \[regsub -all .. {\\1} {} x]]\[
		string repeat {$1} \[expr {\$x ne {}}]]"]
	    ] {\1} a
	return $a
    }

    # Exported operations
    proc eq {a b} {
	expr {$a eq $b}
    }
    proc add {a b} {
	variable zero
	while {![eq $b $zero]} {
	    zincr a
	    zdecr b
	}
	return $a
    }
    proc sub {a b} {
	variable zero
	while {![eq $b $zero]} {
	    zdecr a
	    zdecr b
	}
	return $a
    }
    proc mul {a b} {
	variable zero
	variable one
	if {[eq $a $zero] || [eq $b $zero]} {return $zero}
	if {[eq $a $one]} {return $b}
	if {[eq $b $one]} {return $a}
	set c $a
	while {![eq [zdecr b] $zero]} {
	    set c [add $c $a]
	}
	return $c
    }
    proc div {a b} {
	variable zero
	variable one
	if {[eq $b $zero]} {error "div zero"}
	if {[eq $a $zero] || [eq $b $one]} {return $a}
	set r $zero
	while {![eq $a $zero]} {
	    if {![eq $a [add [set a [sub $a $b]] $b]]} break
	    zincr r
	}
	return $r
    }
    # Note that there aren't any ordering operations in this version

    # Assemble into a coherent API
    namespace export \[a-y\]*
    namespace ensemble create
}
