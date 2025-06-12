proc makeDirectedGraph arcs {
    # Assume that all nodes are connected to something
    foreach arc $arcs {
	lassign $arc v1 v2 cost
	dict set graph $v1 $v2 $cost
    # dict set graph $v2 $v1 $cost ; # make undirected by adding reverse weight
    }
    return $graph
}

#                      a----7---b
#                     / \      / \
#                    /   9   10  15
#                   /     \  /     \
#                  14      c---11---d---6---e
#                 /       /                /
#                /       2                9
#               f-------/----------------/
#
#

# directed edges
set arcs {
    {a b 7} {a c 9} {a f 14}
    {b c 10} {b d 15}
    {c d 11} {c f 2}
    {d e 6}
    {e f 9}
}

# processing starts here
lassign [dijkstra [makeDirectedGraph $arcs] "a"] costs path
puts "path from a to e costs [dict get $costs e]"
puts "route from a to e is: [join [dict get $path e] { -> }]"
