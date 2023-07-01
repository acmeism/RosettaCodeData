package require Tcl 8.6
# Only for lmap, which can be replaced with foreach

proc joinTables {tableA a tableB b} {
    # Optimisation: if the first table is longer, do in reverse order
    if {[llength $tableB] < [llength $tableA]} {
	return [lmap pair [joinTables $tableB $b $tableA $a] {
	    lreverse $pair
	}]
    }

    foreach value $tableA {
	lappend hashmap([lindex $value $a]) [lreplace $value $a $a]
	#dict version# dict lappend hashmap [lindex $value $a] [lreplace $value $a $a]
    }
    set result {}
    foreach value $tableB {
	set key [lindex $value $b]
	if {![info exists hashmap($key)]} continue
	#dict version# if {![dict exists $hashmap $key]} continue
	foreach first $hashmap($key) {
	    #dict version# foreach first [dict get $hashmap $key]
	    lappend result [list {*}$first $key {*}[lreplace $value $b $b]]
	}
    }
    return $result
}

set tableA {
    {27 "Jonah"} {18 "Alan"} {28 "Glory"} {18 "Popeye"} {28 "Alan"}
}
set tableB {
    {"Jonah" "Whales"} {"Jonah" "Spiders"} {"Alan" "Ghosts"} {"Alan" "Zombies"}
    {"Glory" "Buffy"}
}
set joined [joinTables $tableA 1 $tableB 0]
foreach row $joined {
    puts $row
}
