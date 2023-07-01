proc lreplaceip {_list args} {
        upvar 1 $_list list
        set list [lreplace $list[set list {}] {*}$args]
}

set l {56 21 71 27 39 62 87 76 82 94 45 83 65 45 28 90 52 44 1 89}

for {set i 0} {$i < [llength $l]} {} {
        if {[lindex $l $i] % 2 == 1} {
                lreplaceip l $i $i
        } else {
                incr i
        }
}

puts $l
