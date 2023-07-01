package require Tcl 8.6

proc hammingWeight {n} {
    tcl::mathop::+ {*}[split [format %llb $n] ""]
}
for {set n 0;set l {}} {$n<30} {incr n} {
    lappend l [hammingWeight [expr {3**$n}]]
}
puts "p3: $l"
for {set n 0;set e [set o {}]} {[llength $e]<30||[llength $o]<30} {incr n} {
    lappend [expr {[hammingWeight $n]&1 ? "o" : "e"}] $n
}
puts "evil: [lrange $e 0 29]"
puts "odious: [lrange $o 0 29]"
