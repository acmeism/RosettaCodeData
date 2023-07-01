namespace eval gray {
    proc encode n {
	expr {$n ^ $n >> 1}
    }
    proc decode n {
	# Compute some bit at least as large as MSB
	set i [expr {2**int(ceil(log($n+1)/log(2)))}]
	set b [set bprev [expr {$n & $i}]]
	while {[set i [expr {$i >> 1}]]} {
	    set b [expr {$b | [set bprev [expr {$n & $i ^ $bprev >> 1}]]}]
	}
	return $b
    }
}
