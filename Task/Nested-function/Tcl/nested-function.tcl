#!/usr/bin/env tclsh

proc MakeList separator {
    set counter 1
    proc MakeItem string {
	upvar 1 separator separator counter counter
	set res $counter$separator$string\n
	incr counter
	return $res
    }
    set res [MakeItem first][MakeItem second][MakeItem third]
    rename MakeItem {}
    return $res
}
puts [MakeList ". "]
