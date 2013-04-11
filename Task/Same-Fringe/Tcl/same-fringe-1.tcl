package require Tcl 8.6
package require struct::tree

# A wrapper round a coroutine for iterating over the leaves of a tree in order
proc leafiterator {tree} {
    coroutine coro[incr ::coroutines] apply {tree {
	yield [info coroutine]
	$tree walk [$tree rootname] node {
	    if {[$tree isleaf $node]} {
		yield $node
	    }
	}
	yieldto break
    }} $tree
}

# Compare two trees for equality of their leaf node names
proc samefringe {tree1 tree2} {
    set c1 [leafiterator $tree1]
    set c2 [leafiterator $tree2]
    try {
	while 1 {
	    if {[set l1 [$c1]] ne [set l2 [$c2]]} {
		puts "$l1 != $l2";    # Just so we can see where we failed
		return 0
	    }
	}
	return 1
    } finally {
	rename $c1 {}
	rename $c2 {}
    }
}
