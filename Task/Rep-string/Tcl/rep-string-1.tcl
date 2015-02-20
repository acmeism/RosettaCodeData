proc repstring {text} {
    set len [string length $text]
    for {set i [expr {$len/2}]} {$i > 0} {incr i -1} {
	set sub [string range $text 0 [expr {$i-1}]]
	set eq [string repeat $sub [expr {int(ceil($len/double($i)))}]]
	if {[string equal -length $len $text $eq]} {
	    return $sub
	}
    }
    error "no repetition"
}
