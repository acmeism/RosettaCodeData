proc ProperDivisors {n} {
    if {$n == 1} {return 0}
    set divs 1
    set sum 1
    for {set i 2} {$i*$i <= $n} {incr i} {
        if {! ($n % $i)} {
            lappend divs $i
            incr sum $i
            if {$i*$i<$n} {
                lappend divs [set d [expr {$n / $i}]]
                incr sum $d
            }
        }
    }
    list $sum $divs
}

proc cmp {i j} {    ;# analogous to [string compare], but for numbers
    if {$i == $j} {return 0}
    if {$i > $j} {return 1}
    return -1
}

proc classify {k} {
    lassign [ProperDivisors $k] p    ;# we only care about the first part of the result
    dict get {
        1   abundant
        0   perfect
       -1   deficient
    } [cmp $k $p]
}

puts "Classifying the integers in \[1, 20_000\]:"
set classes {}    ;# this will be a dict

for {set i 1} {$i <= 20000} {incr i} {
    set class [classify $i]
    dict incr classes $class
}

# using [lsort] to order the dictionary by value:
foreach {kind count} [lsort -stride 2 -index 1 -integer $classes] {
    puts "$kind: $count"
}
