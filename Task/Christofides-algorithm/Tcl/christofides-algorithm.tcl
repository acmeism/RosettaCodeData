#!/usr/bin/tclsh

# --- Helper Functions ---

proc print_container {container name} {
    puts "$name: \[[join $container ", "]\]"
}

proc print_edges {edges name} {
    set edge_strings {}
    foreach edge $edges {
        lassign $edge u v weight
        lappend edge_strings [format "(%d, %d, %.2f)" $u $v $weight]
    }
    puts "$name: \[[join $edge_strings ", "]\]"
}

proc print_graph {graph name} {
    puts "$name: \{"
    set n [llength $graph]
    for {set i 0} {$i < $n} {incr i} {
        set row [lindex $graph $i]
        set pairs {}
        for {set j 0} {$j < $n} {incr j} {
            if {$i != $j} {
                set val [lindex $row $j]
                lappend pairs [format "%d: %.2f" $j $val]
            }
        }
        set comma [expr {$i == $n-1 ? "" : ","}]
        puts "  $i: \{[join $pairs ", "]\}$comma"
    }
    puts "\}"
}

# --- Euclidean Distance ---
proc get_length {p1 p2} {
    lassign $p1 x1 y1 id1
    lassign $p2 x2 y2 id2
    set dx [expr {$x1 - $x2}]
    set dy [expr {$y1 - $y2}]
    return [expr {sqrt($dx * $dx + $dy * $dy)}]
}

# --- Build Complete Graph (Adjacency Matrix) ---
proc build_graph {data} {
    set n [llength $data]
    set graph {}

    for {set i 0} {$i < $n} {incr i} {
        set row {}
        for {set j 0} {$j < $n} {incr j} {
            lappend row 0.0
        }
        lappend graph $row
    }

    for {set i 0} {$i < $n} {incr i} {
        for {set j [expr {$i + 1}]} {$j < $n} {incr j} {
            set dist [get_length [lindex $data $i] [lindex $data $j]]
            set row_i [lindex $graph $i]
            set row_j [lindex $graph $j]
            lset row_i $j $dist
            lset row_j $i $dist
            lset graph $i $row_i
            lset graph $j $row_j
        }
    }

    return $graph
}

# --- Union-Find Data Structure ---
namespace eval UnionFind {
    variable parent
    variable rank

    proc new {n} {
        variable parent
        variable rank
        set ns [namespace current]
        set parent($ns) {}
        set rank($ns) {}

        for {set i 0} {$i < $n} {incr i} {
            lappend parent($ns) $i
            lappend rank($ns) 0
        }
        return $ns
    }

    proc find {ns i} {
        variable parent
        variable rank
        set pi [lindex $parent($ns) $i]
        if {$pi != $i} {
            set root [find $ns $pi]
            set new_parent [lreplace $parent($ns) $i $i $root]
            set parent($ns) $new_parent
            return $root
        }
        return $i
    }

    proc unite {ns i j} {
        variable parent
        variable rank
        set root_i [find $ns $i]
        set root_j [find $ns $j]

        if {$root_i != $root_j} {
            set rank_i [lindex $rank($ns) $root_i]
            set rank_j [lindex $rank($ns) $root_j]

            if {$rank_i < $rank_j} {
                set new_parent [lreplace $parent($ns) $root_i $root_i $root_j]
                set parent($ns) $new_parent
            } elseif {$rank_i > $rank_j} {
                set new_parent [lreplace $parent($ns) $root_j $root_j $root_i]
                set parent($ns) $new_parent
            } else {
                set new_parent [lreplace $parent($ns) $root_j $root_j $root_i]
                set parent($ns) $new_parent
                set new_rank [lreplace $rank($ns) $root_i $root_i [expr {$rank_i + 1}]]
                set rank($ns) $new_rank
            }
        }
    }
}

# --- Minimum Spanning Tree (Kruskal's Algorithm) ---
proc minimum_spanning_tree {graph} {
    set n [llength $graph]
    if {$n == 0} {
        return {}
    }

    set edges {}
    for {set i 0} {$i < $n} {incr i} {
        for {set j [expr {$i + 1}]} {$j < $n} {incr j} {
            set weight [lindex [lindex $graph $i] $j]
            lappend edges [list $i $j $weight]
        }
    }

    # Sort edges by weight
    set edges [lsort -real -index 2 $edges]

    set mst {}
    set uf [UnionFind::new $n]
    set edges_count 0

    foreach edge $edges {
        lassign $edge u v weight
        if {[UnionFind::find $uf $u] != [UnionFind::find $uf $v]} {
            lappend mst $edge
            UnionFind::unite $uf $u $v
            incr edges_count
            if {$edges_count == [expr {$n - 1}]} {
                break
            }
        }
    }

    return $mst
}

# --- Find Vertices with Odd Degree in MST ---
proc find_odd_vertexes {mst n} {
    set degree {}
    for {set i 0} {$i < $n} {incr i} {
        lappend degree 0
    }

    foreach edge $mst {
        lassign $edge u v weight
        set degree_u [lindex $degree $u]
        set degree_v [lindex $degree $v]
        lset degree $u [expr {$degree_u + 1}]
        lset degree $v [expr {$degree_v + 1}]
    }

    set odd_vertices {}
    for {set i 0} {$i < $n} {incr i} {
        if {[lindex $degree $i] % 2 != 0} {
            lappend odd_vertices $i
        }
    }

    return $odd_vertices
}

# --- Shuffle List (Fisher-Yates) ---
proc shuffle_list {list} {
    set result [list]
    foreach item $list {
        set pos [expr {int(rand() * ([llength $result] + 1))}]
        set result [linsert $result $pos $item]
    }
    return $result
}

# --- Minimum Weight Matching (Greedy Heuristic) ---
proc minimum_weight_matching {mst_var graph odd_vertices} {
    upvar $mst_var mst

    # Use a copy to allow modification while iterating
    set current_odd [shuffle_list $odd_vertices]

    # Keep track of vertices already matched in this phase
    set n [llength $graph]
    set matched {}
    for {set i 0} {$i < $n} {incr i} {
        lappend matched 0
    }

    for {set i 0} {$i < [llength $current_odd]} {incr i} {
        set v [lindex $current_odd $i]
        if {[lindex $matched $v]} {
            continue
        }

        set min_length Inf
        set closest_u -1

        # Find the closest unmatched odd vertex
        for {set j [expr {$i + 1}]} {$j < [llength $current_odd]} {incr j} {
            set u [lindex $current_odd $j]
            if {![lindex $matched $u]} {
                set dist [lindex [lindex $graph $v] $u]
                if {$dist < $min_length && $dist != "Inf"} {
                    set min_length $dist
                    set closest_u $u
                }
            }
        }

        if {$closest_u != -1} {
            # Add the matching edge to the MST list (now a multigraph)
            lappend mst [list $v $closest_u $min_length]
            set matched_v [lreplace $matched $v $v 1]
            set matched_u [lreplace $matched_v $closest_u $closest_u 1]
            set matched $matched_u
        }
    }
}

# --- Find Eulerian Tour (Hierholzer's Algorithm) ---
proc find_eulerian_tour {matched_mst n} {
    if {[llength $matched_mst] == 0} {
        return {}
    }

    # Build adjacency list representation of the multigraph
    set adj {}
    for {set i 0} {$i < $n} {incr i} {
        lappend adj {}
    }

    # Create a unique identifier for each edge to track usage
    set edge_counter 0
    array set edge_map {}
    array set edge_used {}

    foreach edge $matched_mst {
        lassign $edge u v weight
        set edge_id "edge_$edge_counter"
        set edge_map($edge_id) $edge
        set edge_used($edge_id) 0
        incr edge_counter

        # Add edge to adjacency list (both directions)
        set adj_u [lindex $adj $u]
        lappend adj_u [list $v $edge_id]
        lset adj $u $adj_u

        set adj_v [lindex $adj $v]
        lappend adj_v [list $u $edge_id]
        lset adj $v $adj_v
    }

    set tour {}
    set current_path {}

    # Start at any vertex with edges
    lassign [lindex $matched_mst 0] start_u start_v start_weight
    lappend current_path $start_u

    while {[llength $current_path] > 0} {
        set current_node [lindex $current_path end]
        set found_edge 0

        # Find an unused edge from the current node
        set neighbors [lindex $adj $current_node]
        set new_neighbors {}

        foreach neighbor_info $neighbors {
            lassign $neighbor_info neighbor edge_id

            if {![info exists edge_used($edge_id)] || !$edge_used($edge_id)} {
                if {!$found_edge} {
                    set edge_used($edge_id) 1
                    lappend current_path $neighbor
                    set found_edge 1
                } else {
                    lappend new_neighbors $neighbor_info
                }
            } else {
                lappend new_neighbors $neighbor_info
            }
        }

        # Update adjacency list to remove used edges
        lset adj $current_node $new_neighbors

        # If no unused edge was found from current_node, backtrack
        if {!$found_edge} {
            set last_node [lindex $current_path end]
            set current_path [lreplace $current_path end end]
            lappend tour $last_node
        }
    }

    # The tour is constructed in reverse order
    set reversed_tour {}
    for {set i [expr {[llength $tour] - 1}]} {$i >= 0} {incr i -1} {
        lappend reversed_tour [lindex $tour $i]
    }
    return $reversed_tour
}

# --- Main TSP Function (Christofides Approximation) ---
proc tsp {data} {
    set n [llength $data]

    if {$n == 0} {
        return [list 0.0 {}]
    }
    if {$n == 1} {
        lassign [lindex $data 0] x y id
        return [list 0.0 [list $id]]
    }

    # Build a graph
    set G [build_graph $data]
    # print_graph $G "Graph"

    # Build a minimum spanning tree
    set MSTree [minimum_spanning_tree $G]
    print_edges $MSTree "MSTree"

    # Find odd degree vertices
    set odd_vertexes [find_odd_vertexes $MSTree $n]
    print_container $odd_vertexes "Odd vertexes in MSTree"

    # Add minimum weight matching edges
    minimum_weight_matching MSTree $G $odd_vertexes
    print_edges $MSTree "Minimum weight matching (MST + Matching Edges)"

    # Find an Eulerian tour in the combined graph
    set eulerian_tour [find_eulerian_tour $MSTree $n]
    # Filter out invalid values from eulerian tour
    set clean_tour {}
    foreach node $eulerian_tour {
        if {$node != "" && $node != "," && [string is integer $node]} {
            lappend clean_tour $node
        }
    }
    set eulerian_tour $clean_tour
    print_container $eulerian_tour "Eulerian tour"

    # --- Create Hamiltonian Circuit by Skipping Visited Nodes ---
    if {[llength $eulerian_tour] == 0} {
        puts "Error: Eulerian tour could not be found."
        return [list -1.0 {}]
    }

    set path {}
    set length 0.0

    set visited {}
    for {set i 0} {$i < $n} {incr i} {
        lappend visited 0
    }

    set current [lindex $eulerian_tour 0]
    lappend path $current
    set visited_current [lreplace $visited $current $current 1]
    set visited $visited_current

    for {set i 1} {$i < [llength $eulerian_tour]} {incr i} {
        set v [lindex $eulerian_tour $i]
        # Validate that v is a proper integer
        if {![string is integer $v] || $v < 0 || $v >= $n} {
            continue
        }
        if {![lindex $visited $v]} {
            lappend path $v
            set visited_v [lreplace $visited $v $v 1]
            set visited $visited_v
            set length [expr {$length + [lindex [lindex $G $current] $v]}]
            set current $v
        }
    }

    # Add the edge back to the start (only if we have a valid path)
    if {[llength $path] > 0} {
        set length [expr {$length + [lindex [lindex $G $current] [lindex $path 0]]}]
        lappend path [lindex $path 0]
    }

    print_container $path "Result path"
    puts [format "Result length of the path: %.2f" $length]

    return [list $length $path]
}

# --- Main Program ---

# Input data matching the C++ example
set raw_data {
    {1380 939} {2848 96} {3510 1671} {457 334} {3888 666} {984 965} {2721 1482} {1286 525}
    {2716 1432} {738 1325} {1251 1832} {2728 1698} {3815 169} {3683 1533} {1247 1945} {123 862}
    {1234 1946} {252 1240} {611 673} {2576 1676} {928 1700} {53 857} {1807 1711} {274 1420}
    {2574 946} {178 24} {2678 1825} {1795 962} {3384 1498} {3520 1079} {1256 61} {1424 1728}
    {3913 192} {3085 1528} {2573 1969} {463 1670} {3875 598} {298 1513} {3479 821} {2542 236}
    {3955 1743} {1323 280} {3447 1830} {2936 337} {1621 1830} {3373 1646} {1393 1368}
    {3874 1318} {938 955} {3022 474} {2482 1183} {3854 923} {376 825} {2519 135} {2945 1622}
    {953 268} {2628 1479} {2097 981} {890 1846} {2139 1806} {2421 1007} {2290 1810} {1115 1052}
    {2588 302} {327 265} {241 341} {1917 687} {2991 792} {2573 599} {19 674} {3911 1673}
    {872 1559} {2863 558} {929 1766} {839 620} {3893 102} {2178 1619} {3822 899} {378 1048}
    {1178 100} {2599 901} {3416 143} {2961 1605} {611 1384} {3113 885} {2597 1830} {2586 1286}
    {161 906} {1429 134} {742 1025} {1625 1651} {1187 706} {1787 1009} {22 987} {3640 43}
    {3756 882} {776 392} {1724 1642} {198 1810} {3950 1558}
}

set data_points {}
for {set i 0} {$i < [llength $raw_data]} {incr i} {
    set point [lindex $raw_data $i]
    lassign $point x y
    lappend data_points [list $x $y $i]
}

tsp $data_points
