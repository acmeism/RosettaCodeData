proc factors {x} {
    # list the prime factors of x in ascending order
    set result [list]
    while {$x % 2 == 0} {
        lappend result 2
        set x [expr {$x / 2}]
    }
    for {set i 3} {$i*$i <= $x} {incr i 2} {
        while {$x % $i == 0} {
            lappend result $i
            set x [expr {$x / $i}]
        }
    }
    if {$x != 1} {lappend result $x}
    return $result
}

proc digitsum {n} {
    ::tcl::mathop::+ {*}[split $n ""]
}

proc smith? {n} {
    set fs [factors $n]
    if {[llength $fs] == 1} {
        return false    ;# $n is prime
    }
    expr {[digitsum $n] == [digitsum [join $fs ""]]}
}
proc range {n} {
    for {set i 1} {$i < $n} {incr i} {lappend result $i}
    return $result
}

set smiths [lmap i [range 10000] {
    if {![smith? $i]} continue
    set i
}]

puts [lrange $smiths 0 12]...
puts ...[lrange $smiths end-12 end]
puts "([llength $smiths] total)"
