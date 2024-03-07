package require Tcl 8.6

# Create a coroutine for generating Padovan sequence using lazy evaluation
proc pad_recur {{n 1}} {
    set p1 1
    set p2 1
    set p3 1
    set p4 1
    for {set i 1} {$i <= $n} {incr i} {
        set next [expr {$p2 + $p3}]
        yield $p1
        set p1 $p2
        set p2 $p3
        set p3 $p4
        set p4 $next
    }
}

proc pad_floor {n} {
    set p 1.32471795724474602596
    set s 1.0453567932525329623
    if {$n < 3} {
        return 1 ;# The first three elements should be 1, so return 1 for n < 3
    } else {
        return [expr {int(0.5 + pow($p, double($n)-2) / $s)}]
    }
}

# Main variables
set l 10
set m 20
set n 32

# Generating Padovan sequence using recursive coroutine
set pr [list]
set pad_recur_coro [coroutine pad_recur_co pad_recur $n]
for {set i 1} {$i <= $n} {incr i} {
    lappend pr [pad_recur_co]
}
puts [join [lrange $pr 0 [expr {$m - 1}]] " "]

# Generating Padovan sequence using floor function
set pf [list]
for {set i 1} {$i <= $n} {incr i} {
    lappend pf [pad_floor $i]
}
puts [join [lrange $pf 0 [expr {$m - 1}]] " "]

# Generating L-system sequence
set L [list "A"]
set rules [dict create A B B C C AB]
for {set i 1} {$i <= $n} {incr i} {
    set last [lindex $L end]
    set expansion ""
    foreach char [split $last ""] {
        append expansion [dict get $rules $char]
    }
    lappend L $expansion
}
puts [join [lrange $L 0 [expr {$l - 1}]] " "]

# Comparison of all three methods, adjusting for zero-indexing
for {set i 0} {$i < $m} {incr i} {
    set pr_val [lindex $pr $i]
    set pf_val [lindex $pf $i]
    set L_len [string length [lindex $L $i]]
    if { $pr_val != $pf_val || $pr_val != $L_len } {
        error "Uh oh, n=$i: $pr_val vs $pf_val vs $L_len"
    }
}

puts "100% agreement among all 3 methods."
