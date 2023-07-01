proc entropy {str} {
    set log2 [expr log(2)]
    foreach char [split $str ""] {dict incr counts $char}
    set entropy 0.0
    foreach count [dict values $counts] {
	set freq [expr {$count / double([string length $str])}]
	set entropy [expr {$entropy - $freq * log($freq)/$log2}]
    }
    return $entropy
}

puts [format "entropy = %.5f" [entropy [read [open [info script]]]]]
