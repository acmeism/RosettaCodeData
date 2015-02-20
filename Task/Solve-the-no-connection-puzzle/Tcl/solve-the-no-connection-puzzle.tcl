package require Tcl 8.6
package require struct::list

proc haveAdjacent {a b c d e f g h} {
    expr {
	[edge $a $c] ||
	[edge $a $d] ||
	[edge $a $e] ||
	[edge $b $d] ||
	[edge $b $e] ||
	[edge $b $f] ||
	[edge $c $d] ||
	[edge $c $g] ||
	[edge $d $e] ||
	[edge $d $g] ||
	[edge $d $h] ||
	[edge $e $f] ||
	[edge $e $g] ||
	[edge $e $h] ||
	[edge $f $h]
    }
}
proc edge {x y} {
    expr {abs($x-$y) == 1}
}

set layout [string trim {
        A   B
       /|\ /|\
      / | X | \
     /  |/ \|  \
    C - D - E - F
     \  |\ /|  /
      \ | X | /
       \|/ \|/
        G   H
} \n]
struct::list foreachperm p {1 2 3 4 5 6 7 8} {
    if {![haveAdjacent {*}$p]} {
	puts [string map [join [
	    lmap name {A B C D E F G H} val $p {list $name $val}
	]] $layout]
	break
    }
}
