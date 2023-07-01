# Helpers to make construction and listing of a whole tree simpler
proc Tree nested {
    lassign $nested v l r
    if {$l ne ""} {set l [Tree $l]}
    if {$r ne ""} {set r [Tree $r]}
    tree new $v $l $r
}
proc Listify {tree order} {
    set list {}
    $tree $order v {
	lappend list $v
    }
    return $list
}

# Make a tree, print it a few ways, and destroy the tree
set t [Tree {1 {2 {4 7} 5} {3 {6 8 9}}}]
puts "preorder:    [Listify $t preorder]"
puts "inorder:     [Listify $t inorder]"
puts "postorder:   [Listify $t postorder]"
puts "level-order: [Listify $t levelorder]"
$t destroy
