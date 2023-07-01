proc lreplaceip {_list args} {
        upvar 1 $_list list
        set list [lreplace $list[set list {}] {*}$args]
}

proc iota {n {start 0}} {
        set res {}
        set end [expr {$start + $n}]
        for {set i $start} {$i <= $end} {incr i} {
                lappend res $i
        }
        return $res
}

foreach e {5 6 7} {
        set l [iota 1e$e]
        puts 1e$e
        puts "    lreplace:   [time {set l [lreplace $l end end]}]"
        puts "    lreplaceip: [time {lreplaceip l end end}]"
}
