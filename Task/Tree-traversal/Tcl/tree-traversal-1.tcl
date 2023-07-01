oo::class create tree {
    # Basic tree data structure stuff...
    variable val l r
    constructor {value {left {}} {right {}}} {
	set val $value
	set l $left
	set r $right
    }
    method value {} {return $val}
    method left  {} {return $l}
    method right {} {return $r}
    destructor {
	if {$l ne ""} {$l destroy}
	if {$r ne ""} {$r destroy}
    }

    # Traversal methods
    method preorder {varName script {level 0}} {
	upvar [incr level] $varName var
	set var $val
	uplevel $level $script
	if {$l ne ""} {$l preorder $varName $script $level}
	if {$r ne ""} {$r preorder $varName $script $level}
    }
    method inorder {varName script {level 0}} {
	upvar [incr level] $varName var
	if {$l ne ""} {$l inorder $varName $script $level}
	set var $val
	uplevel $level $script
	if {$r ne ""} {$r inorder $varName $script $level}
    }
    method postorder {varName script {level 0}} {
	upvar [incr level] $varName var
	if {$l ne ""} {$l postorder $varName $script $level}
	if {$r ne ""} {$r postorder $varName $script $level}
	set var $val
	uplevel $level $script
    }
    method levelorder {varName script} {
	upvar 1 $varName var
	set nodes [list [self]]; # A queue of nodes to process
	while {[llength $nodes] > 0} {
	    set nodes [lassign $nodes n]
	    set var [$n value]
	    uplevel 1 $script
	    if {[$n left] ne ""} {lappend nodes [$n left]}
	    if {[$n right] ne ""} {lappend nodes [$n right]}
	}
    }
}
