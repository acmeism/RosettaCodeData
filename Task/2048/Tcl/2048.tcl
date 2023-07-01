# A minimal implementation of the game 2048 in Tcl.
# For a maintained version with expanded functionality see
# https://tcl.wiki/40557.
package require Tcl 8.5
package require struct::matrix
package require struct::list

# Board size.
set size 4

# Iterate over all cells of the game board and run script for each.
#
# The game board is a 2D matrix of a fixed size that consists of elements
# called "cells" that each can contain a game tile (corresponds to numerical
# values of 2, 4, 8, ..., 2048) or nothing (zero).
#
# - cellList is a list of cell indexes (coordinates), which are
# themselves lists of two numbers each. They each represent the location
# of a given cell on the board.
# - varName1 are varName2 are names of the variables the will be assigned
# the index values.
# - cellVarName is the name of the variable that at each step of iteration
# will contain the numerical value of the present cell. Assigning to it will
# change the cell's value.
# - script is the script to run.
proc forcells {cellList varName1 varName2 cellVarName script} {
    upvar $varName1 i
    upvar $varName2 j
    upvar $cellVarName c
    foreach cell $cellList {
        set i [lindex $cell 0]
        set j [lindex $cell 1]
        set c [cell-get $cell]
        uplevel $script
        cell-set "$i $j" $c
    }
}

# Generate a list of cell indexes for all cells on the board, i.e.,
# {{0 0} {0 1} ... {0 size-1} {1 0} {1 1} ... {size-1 size-1}}.
proc cell-indexes {} {
    global size
    set list {}
    foreach i [::struct::list iota $size] {
        foreach j [::struct::list iota $size] {
            lappend list [list $i $j]
        }
    }
    return $list
}

# Check if a number is a valid cell index (is 0 to size-1).
proc valid-index {i} {
    global size
    expr {0 <= $i && $i < $size}
}

# Return 1 if the predicate pred is true when applied to all items on the list
# or 0 otherwise.
proc map-and {list pred} {
    set res 1
    foreach item $list {
        set res [expr {$res && [$pred $item]}]
        if {! $res} break
    }
    return $res
}

# Check if list represents valid cell coordinates.
proc valid-cell? cell {
    map-and $cell valid-index
}

# Get the value of a game board cell.
proc cell-get cell {
    board get cell {*}$cell
}

# Set the value of a game board cell.
proc cell-set {cell value} {
    board set cell {*}$cell $value
}

# Filter a list of board cell indexes cellList to only have those indexes
# that correspond to empty board cells.
proc empty {cellList} {
    ::struct::list filterfor x $cellList {[cell-get $x] == 0}
}

# Pick a random item from the given list.
proc pick list {
    lindex $list [expr {int(rand() * [llength $list])}]
}

# Put a "2" into an empty cell on the board.
proc spawn-new {} {
    set emptyCell [pick [empty [cell-indexes]]]
    if {[llength $emptyCell] > 0} {
        forcells [list $emptyCell] i j cell {
            set cell 2
        }
    }
    return $emptyCell
}

# Return vector sum of lists v1 and v2.
proc vector-add {v1 v2} {
    set result {}
    foreach a $v1 b $v2 {
        lappend result [expr {$a + $b}]
    }
    return $result
}

# If checkOnly is false try to shift all cells one step in the direction of
# directionVect. If checkOnly is true just say if that move is possible.
proc move-all {directionVect {checkOnly 0}} {
    set changedCells 0

    forcells [cell-indexes] i j cell {
        set newIndex [vector-add "$i $j" $directionVect]
        set removedStar 0

        # For every nonempty source cell and valid destination cell...
        if {$cell != 0 && [valid-cell? $newIndex]} {
            if {[cell-get $newIndex] == 0} {
                # Destination is empty.
                if {$checkOnly} {
                    # -level 2 is to return from both forcells and move-all.
                    return -level 2 true
                } else {
                    # Move tile to empty cell.
                    cell-set $newIndex $cell
                    set cell 0
                    incr changedCells
                }
            } elseif {([cell-get $newIndex] eq $cell) &&
                      [string first + $cell] == -1} {
                # Destination is the same number as source.
                if {$checkOnly} {
                    return -level 2 true
                } else {
                    # When merging two tiles into one mark the new tile with
                    # the marker of "+" to ensure it doesn't get combined
                    # again this turn.
                    cell-set $newIndex [expr {2 * $cell}]+
                    set cell 0
                    incr changedCells
                }
            }
        }
    }

    if {$checkOnly} {
        return false
    }

    # Remove "changed this turn" markers at the end of the turn.
    if {$changedCells == 0} {
        forcells [cell-indexes] i j cell {
            set cell [string trim $cell +]
        }
    }
    return $changedCells
}

# Is it possible to move any tiles in the direction of directionVect?
proc can-move? {directionVect} {
    move-all $directionVect 1
}

# Check win condition. The player wins when there's a 2048 tile.
proc check-win {} {
    forcells [cell-indexes] i j cell {
        if {$cell == 2048} {
            puts "You win!"
            exit 0
        }
    }
}

# Check lose condition. The player loses when the win condition isn't met and
# there are no possible moves.
proc check-lose {possibleMoves} {
    set values [dict values $possibleMoves]
    if {!(true in $values || 1 in $values)} {
        puts "You lose."
        exit 0
    }
}

# Pretty-print the board. Specify an index in highlight to highlight a cell.
proc print-board {{highlight {-1 -1}}} {
    forcells [cell-indexes] i j cell {
        if {$j == 0} {
            puts ""
        }
        puts -nonewline [
            if {$cell != 0} {
                if {[::struct::list equal "$i $j" $highlight]} {
                    format "\[%4s\]" $cell*
                } else {
                    format "\[%4s\]" $cell
                }

            } else {
                lindex "......"
            }
        ]
    }
    puts "\n"
}

proc main {} {
    global size

    struct::matrix board

    # Generate an empty board of a given size.
    board add columns $size
    board add rows $size
    forcells [cell-indexes] i j cell {
        set cell 0
    }

    set controls {
        h {0 -1}
        j {1 0}
        k {-1 0}
        l {0 1}
    }

    # Game loop.
    while true {
        set playerMove 0
        set possibleMoves {}

        # Add new tile to the board and print the board highlighting this tile.
        print-board [spawn-new]

        check-win

        # Find possible moves.
        foreach {button vector} $controls {
            dict set possibleMoves $button [can-move? $vector]
        }
        check-lose $possibleMoves

        # Get valid input from the player.
        while {$playerMove == 0} {
            # Print prompt.
            puts -nonewline "Move ("
            foreach {button vector} $controls {
                if {[dict get $possibleMoves $button]} {
                    puts -nonewline $button
                }
            }
            puts ")?"

            set playerInput [gets stdin]

            # Validate input.
            if {[dict exists $possibleMoves $playerInput] &&
                [dict get $possibleMoves $playerInput]} {
                set playerMove [dict get $controls $playerInput]
            }
        }

        # Apply current move until no changes occur on the board.
        while true {
            if {[move-all $playerMove] == 0} break
        }
    }
}

main
