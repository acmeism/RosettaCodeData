package require Tcl 8.6

oo::class create MoveToFront {
    variable symbolTable
    constructor {symbols} {
	set symbolTable [split $symbols ""]
    }

    method MoveToFront {table index} {
	list [lindex $table $index] {*}[lreplace $table $index $index]
    }
    method encode {text} {
	set t $symbolTable
	set r {}
	foreach c [split $text ""] {
	    set i [lsearch -exact $t $c]
	    lappend r $i
	    set t [my MoveToFront $t $i]
	}
	return $r
    }
    method decode {numbers} {
	set t $symbolTable
	set r ""
	foreach n $numbers {
	    append r [lindex $t $n]
	    set t [my MoveToFront $t $n]
	}
	return $r
    }
}

MoveToFront create mtf "abcdefghijklmnopqrstuvwxyz"
foreach tester {"broood" "bananaaa" "hiphophiphop"} {
    set enc [mtf encode $tester]
    set dec [mtf decode $enc]
    puts [format "'%s' encodes to %s. This decodes to '%s'. %s" \
	    $tester $enc $dec [expr {$tester eq $dec ? "Correct!" : "WRONG!"}]]
}
