# Render a hand (or any list) of cards (the "."s are just placeholders).
proc PrettyHand {hand {separator \n}} {
    set Co {. red green . purple}
    set Sy {. oval squiggle . diamond}
    set Nu {. one two . three}
    set Sh {. solid open . striped}
    foreach card $hand {
	lassign $card co s n sh
	lappend result [format "(%s,%s,%s,%s)" \
		[lindex $Co $co] [lindex $Sy $s] [lindex $Nu $n] [lindex $Sh $sh]]
    }
    return $separator[join $result $separator]
}

# Render the output of the Set Puzzle solver.
proc PrettyOutput {setResult} {
    lassign $setResult hand sets
    set sep "\n   "
    puts "Hand (with [llength $hand] cards) was:[PrettyHand $hand $sep]"
    foreach s $sets {
	puts "Found set [incr n]:[PrettyHand $s $sep]"
    }
}

# Demonstrate on the two cases
puts "=== BASIC PUZZLE ========="
PrettyOutput [SetPuzzle 9 4]
puts "=== ADVANCED PUZZLE ======"
PrettyOutput [SetPuzzle 12 6]
