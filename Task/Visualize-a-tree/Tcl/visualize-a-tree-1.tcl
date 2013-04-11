package require struct::tree

proc visualize_tree {tree {nameattr name}} {
    set path {}
    $tree walk [$tree rootname] -order both {mode node} {
	if {$mode eq "enter"} {
	    set s ""
	    foreach p $path {
		append s [expr {[$tree next $p] eq "" ? "  " : "\u2502 "}]
	    }
	    lappend path $node
	    append s [expr {
		[$tree next $node] eq "" ? "\u2514\u2500" : "\u251c\u2500"
	    }]
	    if {[$tree keyexists $node $nameattr]} {
		set name [$tree get $node $nameattr]
	    } else {
		# No node name attribute; use the raw name
		set name $node
	    }
	    puts "$s$name"
	} else {
	    set path [lrange $path 0 end-1]
	}
    }
}
