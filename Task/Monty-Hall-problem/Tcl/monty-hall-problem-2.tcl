package require Tcl 8.5

# Utility: pick a random item from a list
proc pick list {
    lindex $list [expr {int(rand()*[llength $list])}]
}
# Utility: remove an item from a list if it is there
proc remove {list item} {
    set idx [lsearch -exact $list $item]
    return [lreplace $list $idx $idx]
}

# Codify how Monty will present the new set of doors to choose between
proc MontyHallAction {doors car picked} {
    set unpicked [remove $doors $picked]
    if {$car in $unpicked} {
        # Remove a random unpicked door without the car behind it
        set carless [remove $unpicked $car]
        return [list {*}[remove $carless [pick $carless]] $car]
        # Expressed this way so Monty Hall isn't theoretically
        # restricted to using 3 doors, though that could be written
        # as just: return [list $car]
    } else {
        # Monty has a real choice now...
        return [remove $unpicked [pick $unpicked]]
    }
}

# The different strategies you might choose
proc Strategy:Stay {originalPick otherChoices} {
    return $originalPick
}
proc Strategy:Change {originalPick otherChoices} {
    return [pick $otherChoices]
}
proc Strategy:PickAnew {originalPick otherChoices} {
    return [pick [list $originalPick {*}$otherChoices]]
}

# Codify one round of the game
proc MontyHallGameRound {doors strategy winCounter} {
    upvar 1 $winCounter wins
    set car [pick $doors]
    set picked [pick $doors]
    set newDoors [MontyHallAction $doors $car $picked]
    set picked [$strategy $picked $newDoors]
    # Check for win...
    if {$car eq $picked} {
        incr wins
    }
}

# We're always using three doors
set threeDoors {a b c}
set stay 0; set change 0; set anew 0
set total 10000
# Simulate each of the different strategies
for {set i 0} {$i<$total} {incr i} {
    MontyHallGameRound $threeDoors Strategy:Stay     stay
    MontyHallGameRound $threeDoors Strategy:Change   change
    MontyHallGameRound $threeDoors Strategy:PickAnew anew
}
# Print the results
puts "Estimate: $stay/$total wins for 'staying' strategy"
puts "Estimate: $change/$total wins for 'changing' strategy"
puts "Estimate: $anew/$total wins for 'picking anew' strategy"
