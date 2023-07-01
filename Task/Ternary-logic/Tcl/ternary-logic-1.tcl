package require Tcl 8.5
namespace eval ternary {
    # Code generator
    proc maketable {name count values} {
	set sep ""
	for {set i 0; set c 97} {$i<$count} {incr i;incr c} {
	    set v [format "%c" $c]
	    lappend args $v; append key $sep "$" $v
	    set sep ","
	}
	foreach row [split $values \n] {
	    if {[llength $row]>1} {
		lassign $row from to
		lappend table $from [list return $to]
	    }
	}
	proc $name $args \
	    [list ckargs $args]\;[concat [list switch -glob --] $key [list $table]]
	namespace export $name
    }
    # Helper command to check argument syntax
    proc ckargs argList {
	foreach var $argList {
	    upvar 1 $var v
	    switch -exact -- $v {
		true - maybe - false {
		    continue
		}
		default {
		    return -level 2 -code error "bad ternary value \"$v\""
		}
	    }
	}
    }

    # The "truth" tables; “*” means “anything”
    maketable not 1 {
	true false
	maybe maybe
	false true
    }
    maketable and 2 {
	true,true true
	false,* false
	*,false false
	* maybe
    }
    maketable or 2 {
	true,* true
	*,true true
	false,false false
	* maybe
    }
    maketable implies 2 {
	false,* true
	*,true true
	true,false false
	* maybe
    }
    maketable equiv 2 {
	*,maybe maybe
	maybe,* maybe
	true,true true
	false,false true
	* false
    }
}
