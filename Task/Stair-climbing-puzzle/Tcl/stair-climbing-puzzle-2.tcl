proc step-up-iter {} {
    for {incr d} {$d} {incr d} {
	incr d [set s -[step]]; incr d $s
    }
}
