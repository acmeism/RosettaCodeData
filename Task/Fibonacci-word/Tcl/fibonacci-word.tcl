proc fibwords {n} {
    set fw {1 0}
    while {[llength $fw] < $n} {
	lappend fw [lindex $fw end][lindex $fw end-1]
    }
    return $fw
}

proc fibwordinfo {num word} {
    # Entropy calculator from Tcl solution of that task
    set log2 [expr log(2)]
    set len [string length $word]
    foreach char [split $word ""] {dict incr counts $char}
    set entropy 0.0
    foreach count [dict values $counts] {
	set freq [expr {$count / double($len)}]
	set entropy [expr {$entropy - $freq * log($freq)/$log2}]
    }
    # Output formatting from Clojure solution
    puts [format "%2d %10d %.15f %s" $num $len $entropy \
	    [if {$len < 35} {set word} {subst "<too long>"}]]
}

# Output formatting from Clojure solution
puts [format "%2s %10s %17s %s" N Length Entropy Fibword]
foreach word [fibwords 37] {
    fibwordinfo [incr i] $word
}
