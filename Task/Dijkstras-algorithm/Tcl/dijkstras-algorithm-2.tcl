proc makeUndirectedGraph arcs {
    # Assume that all nodes are connected to something
    foreach arc $arcs {
	lassign $arc v1 v2 cost
	dict set graph $v1 $v2 $cost
	dict set graph $v2 $v1 $cost
    }
    return $graph
}
set arcs {
    {a b 7} {a c 9} {b c 10} {b d 15} {c d 11}
    {d e 6} {a f 14} {c f 2} {e f 9}
}
lassign [dijkstra [makeUndirectedGraph $arcs] "a"] costs path
puts "path from a to e costs [dict get $costs e]"
puts "route from a to e is: [join [dict get $path e] { -> }]"
