package require struct::list

proc chess960 {} {
    while true {
	set pos [join [struct::list shuffle {N N B B R R Q K}] ""]
	if {[regexp {R.*K.*R} $pos] && [regexp {B(..)*B} $pos]} {
	    return $pos
	}
    }
}

# A simple renderer
proc chessRender {position} {
    string map {P ♙ N ♘ B ♗ R ♖ Q ♕ K ♔} $position
}

# Output multiple times just to show scope of positions
foreach - {1 2 3 4 5} {puts [chessRender [chess960]]}
