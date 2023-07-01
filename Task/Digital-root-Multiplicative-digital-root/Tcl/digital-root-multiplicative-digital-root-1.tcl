proc mdr {n} {
    if {$n < 0 || ![string is integer $n]} {
	error "must be an integer"
    }
    for {set i 0} {$n > 9} {incr i} {
	set n [tcl::mathop::* {*}[split $n ""]]
    }
    return [list $i $n]
}
