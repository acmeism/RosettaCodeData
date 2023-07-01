package require Tcl 8.5;		# for arbitrary-precision integers
package require struct::list;		# for permutation enumerator

proc derangements lst {
    # Special case
    if {![llength $lst]} {return {{}}}
    set result {}
    for {set perm [struct::list firstperm $lst]} {[llength $perm]} \
	    {set perm [struct::list nextperm $perm]} {
	set skip 0
	foreach a $lst b $perm {
	    if {[set skip [string equal $a $b]]} break
	}
	if {!$skip} {lappend result $perm}
    }
    return $result
}

proc deranged1to n {
    for {set i 1;set r {}} {$i <= $n} {incr i} {lappend r $i}
    return [derangements $r]
}

proc countDeranged1to n {
    llength [deranged1to $n]
}

proc subfact n {
    if {$n == 0} {return 1}
    if {$n == 1} {return 0}
    set o 1
    set s 0
    for {set i 1} {$i < $n} {incr i} {
	set s [expr {$i * ($o + [set o $s])}]
    }
    return $s
}
