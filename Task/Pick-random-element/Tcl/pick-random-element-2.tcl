# seed rng
set seed [expr { srand([clock clicks]) }]

# return a list of random selections of items from a list
proc random_items { item_list {n 1} {dups no} } {

    # use item_list in place as items
    upvar 1 $item_list items

    set result {}
    set max    [llength $items]

    if { $n > $max} {set n $max}

    set count 0

    while { $count < $n } {	

   	    # random integer index 0..len-1
	    set idx [expr { int(rand() * $max)} ]

	    # pick item
	    set item [lindex $items $idx]

	    # check for dups
	    if {$dups eq no} {
	        set srch [lsearch $result $item]
	        if {$srch > -1} { continue }
	    }

	    lappend result $item
	    incr count   	
    }
    return  $result
 }

# randomize a list in place
proc randomize {item_list} {
    upvar 1 $item_list items
    set len [llength $items]
    set items [random_items items $len]
}

# return a new shuffled list
proc shuffle {items} {
    set len [llength $items]
    return [random_items items $len]
}

# test cases

set animals {
    dog cat bird ant fish
    horse pig cow snake mouse
    whale worm bug spider deer
    bee bear human gecko octopus
}

# 1 item default
set guess [random_items animals]

puts stdout "guess:  $guess \n"

# in place shuffle
randomize animals

# list of 4 random items, no dups
set A [random_items animals 4]
set B [random_items animals 5]
set C [random_items animals 6]

set dashline [string repeat "-" 30]

foreach a {$A $B $C} {
   puts stdout $dashline
   puts stdout "${a}"
}

puts stdout $dashline
