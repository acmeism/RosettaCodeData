package require math::linearalgebra
package require struct::list

proc permanent {matrix} {
    for {set plist {};set i 0} {$i<[llength $matrix]} {incr i} {
	lappend plist $i
    }
    foreach p [::struct::list permutations $plist] {
	foreach i $plist j $p {
	    lappend prod [lindex $matrix $i $j]
	}
	lappend sum [::tcl::mathop::* {*}$prod[set prod {}]]
    }
    return [::tcl::mathop::+ {*}$sum]
}
