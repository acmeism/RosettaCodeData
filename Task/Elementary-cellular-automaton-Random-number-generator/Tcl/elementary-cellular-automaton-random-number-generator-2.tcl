set rng [RandomGenerator new 31]
for {set r {}} {[llength $r]<10} {} {
    lappend r [$rng rand]
}
puts [join $r ,]
