set sorted {}
lmap x $argv {after $x [list lappend sorted $x]}
while {[llength $sorted] != $argc} {
	vwait sorted
}
puts $sorted
