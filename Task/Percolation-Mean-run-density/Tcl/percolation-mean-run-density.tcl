proc randomString {length probability} {
    for {set s ""} {[string length $s] < $length} {} {
	append s [expr {rand() < $probability}]
    }
    return $s
}

# By default, [regexp -all] gives the number of times that the RE matches
proc runs {str} {
    regexp -all {1+} $str
}

# Compute the mean run density
proc mrd {t p n} {
    for {set i 0;set total 0.0} {$i < $t} {incr i} {
	set run [randomString $n $p]
	set total [expr {$total + double([runs $run])/$n}]
    }
    return [expr {$total / $t}]
}

# Parameter sweep with nested [foreach]
set runs 500
foreach p {0.10 0.30 0.50 0.70 0.90} {
    foreach n {1024 4096 16384} {
	set theory [expr {$p * (1 - $p)}]
	set sim [mrd $runs $p $n]
	set diffpc [expr {abs($theory-$sim)*100/$theory}]
	puts [format "t=%d, p=%.2f, n=%5d, p(1-p)=%.3f, sim=%.3f, delta=%.2f%%" \
		      $runs $p $n $theory $sim $diffpc]
    }
    puts ""
}
