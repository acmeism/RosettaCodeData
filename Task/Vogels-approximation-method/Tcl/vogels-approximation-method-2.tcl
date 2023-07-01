set COSTS {
    W {A 16 B 16 C 13 D 22 E 17}
    X {A 14 B 14 C 13 D 19 E 15}
    Y {A 19 B 19 C 20 D 23 E 50}
    Z {A 50 B 12 C 50 D 15 E 11}
}
set DEMAND {A 30 B 20 C 70 D 30 E 60}
set SUPPLY {W 50 X 60 Y 50 Z 50}

set RES [VAM $COSTS $DEMAND $SUPPLY]

puts \t[join [dict keys $DEMAND] \t]
set cost 0
foreach g [dict keys $SUPPLY] {
    puts $g\t[join [lmap n [dict keys $DEMAND] {
	set c [dict get $RES $g $n]
	incr cost [expr {$c * [dict get $COSTS $g $n]}]
	expr {$c ? $c : ""}
    }] \t]
}
puts "\nTotal Cost = $cost"
