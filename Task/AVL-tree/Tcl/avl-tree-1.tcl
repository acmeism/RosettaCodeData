package require TclOO

namespace eval AVL {
    # Class for the overall tree; manages real public API
    oo::class create Tree {
	variable root nil class
	constructor {{nodeClass AVL::Node}} {
	    set class [oo::class create Node [list superclass $nodeClass]]

	    # Create a nil instance to act as a leaf sentinel
	    set nil [my NewNode ""]
	    set root [$nil ref]

	    # Make nil be special
	    oo::objdefine $nil {
		method height {} {return 0}
		method key {} {error "no key possible"}
		method value {} {error "no value possible"}
		method destroy {} {
		    # Do nothing (doesn't prohibit destruction entirely)
		}
		method print {indent increment} {
		    # Do nothing
		}
	    }
	}

	# How to actually manufacture a new node
	method NewNode {key} {
	    if {![info exists nil]} {set nil ""}
	    $class new $key $nil [list [namespace current]::my NewNode]
	}

	# Create a new node in the tree and return it
	method insert {key} {
	    set node [my NewNode $key]
	    if {$root eq $nil} {
		set root $node
	    } else {
		$root insert $node
	    }
	    return $node
	}

	# Find the node for a particular key
	method lookup {key} {
	    for {set node $root} {$node ne $nil} {} {
		if {[$node key] == $key} {
		    return $node
		} elseif {[$node key] > $key} {
		    set node [$node left]
		} else {
		    set node [$node right]
		}
	    }
	    error "no such node"
	}

	# Print a tree out, one node per line
	method print {{indent 0} {increment 1}} {
	    $root print $indent $increment
	    return
	}
    }

    # Class of an individual node; may be subclassed
    oo::class create Node {
	variable key value left right 0 refcount newNode
	constructor {n nil instanceFactory} {
	    set newNode $instanceFactory
	    set 0 [expr {$nil eq "" ? [self] : $nil}]
	    set key $n
	    set value {}
	    set left [set right $0]
	    set refcount 0
	}
	method ref {} {
	    incr refcount
	    return [self]
	}
	method destroy {} {
	    if {[incr refcount -1] < 1} next
	}
	method New {key value} {
	    set n [{*}$newNode $key]
	    $n setValue $value
	    return $n
	}

	# Getters
	method key {} {return $key}
	method value {} {return $value}
	method left {} {return $left}
	method right {args} {return $right}

	# Setters
	method setValue {newValue} {
	    set value $newValue
	}
	method setLeft {node} {
	    # Non-trivial because of reference management
	    $node ref
	    $left destroy
	    set left $node
	    return
	}
	method setRight {node} {
	    # Non-trivial because of reference management
	    $node ref
	    $right destroy
	    set right $node
	    return
	}

	# Print a node and its descendents
	method print {indent increment} {
	    puts [format "%s%s => %s" [string repeat " " $indent] $key $value]
	    incr indent $increment
	    $left print $indent $increment
	    $right print $indent $increment
	}

	method height {} {
	    return [expr {max([$left height], [$right height]) + 1}]
	}
	method balanceFactor {} {
	    expr {[$left height] - [$right height]}
	}

	method insert {node} {
	    # Simple insertion
	    if {$key > [$node key]} {
		if {$left eq $0} {
		    my setLeft $node
		} else {
		    $left insert $node
		}
	    } else {
		if {$right eq $0} {
		    my setRight $node
		} else {
		    $right insert $node
		}
	    }

	    # Rebalance this node
	    if {[my balanceFactor] > 1} {
		if {[$left balanceFactor] < 0} {
		    $left rotateLeft
		}
		my rotateRight
	    } elseif {[my balanceFactor] < -1} {
		if {[$right balanceFactor] > 0} {
		    $right rotateRight
		}
		my rotateLeft
	    }
	}

	# AVL Rotations
	method rotateLeft {} {
	    set new [my New $key $value]
	    set key [$right key]
	    set value [$right value]
	    $new setLeft $left
	    $new setRight [$right left]
	    my setLeft $new
	    my setRight [$right right]
	}

	method rotateRight {} {
	    set new [my New $key $value]
	    set key [$left key]
	    set value [$left value]
	    $new setLeft [$left right]
	    $new setRight $right
	    my setLeft [$left left]
	    my setRight $new
	}
    }
}
