# Global variable to store cliques
set cliques {}

# Procedure to print a list (equivalent to print_vector)
proc print_list {lst} {
    puts -nonewline "\["
    set len [llength $lst]
    for {set i 0} {$i < $len} {incr i} {
        if {$i > 0} {
            puts -nonewline ", "
        }
        puts -nonewline [lindex $lst $i]
    }
    puts -nonewline "\]"
}

# Procedure to print 2D list (equivalent to print_2D_vector)
proc print_2D_list {lists} {
    puts -nonewline "\["
    set len [llength $lists]
    for {set i 0} {$i < $len} {incr i} {
        if {$i > 0} {
            puts -nonewline ", "
        }
        print_list [lindex $lists $i]
    }
    puts "\]"
}

# Helper procedure to find set difference
proc set_difference {set1 set2} {
    set result {}
    foreach item $set1 {
        if {$item ni $set2} {
            lappend result $item
        }
    }
    return $result
}

# Helper procedure to find set intersection
proc set_intersection {set1 set2} {
    set result {}
    foreach item $set1 {
        if {$item in $set2} {
            lappend result $item
        }
    }
    return $result
}

# Helper procedure to find union of two sets
proc set_union {set1 set2} {
    set result {}
    foreach item $set1 {
        lappend result $item
    }
    foreach item $set2 {
        if {$item ni $result} {
            lappend result $item
        }
    }
    return $result
}

# Bron-Kerbosch algorithm implementation
proc bron_kerbosch {current_clique candidates processed_vertices graph} {
    global cliques

    # Check if both candidates and processed_vertices are empty
    if {[llength $candidates] == 0 && [llength $processed_vertices] == 0} {
        if {[llength $current_clique] > 2} {
            lappend cliques $current_clique
            set cliques $cliques
        }
        return
    }

    # Select pivot vertex with maximum degree
    set union_set [set_union $candidates $processed_vertices]
    set pivot ""
    set max_degree -1

    foreach vertex $union_set {
        set degree [llength [dict get $graph $vertex]]
        if {$degree > $max_degree} {
            set max_degree $degree
            set pivot $vertex
        }
    }

    # Find possibles: vertices in candidates that are not neighbors of pivot
    set pivot_neighbors [dict get $graph $pivot]
    set possibles [set_difference $candidates $pivot_neighbors]

    foreach vertex $possibles {
        # Create new clique including vertex
        set new_clique $current_clique
        lappend new_clique $vertex

        # Find new candidates: members of candidates that are neighbors of vertex
        set vertex_neighbors [dict get $graph $vertex]
        set new_candidates [set_intersection $candidates $vertex_neighbors]

        # Find new processed vertices: members of processed_vertices that are neighbors of vertex
        set new_processed_vertices [set_intersection $processed_vertices $vertex_neighbors]

        # Recursive call
        bron_kerbosch $new_clique $new_candidates $new_processed_vertices $graph

        # Move vertex from candidates to processed_vertices
        set candidates [set_difference $candidates [list $vertex]]
        lappend processed_vertices $vertex
    }
}

# Main procedure
proc main {} {
    global cliques

    # Define edges
    set edges {
        {a b} {b a} {a c} {c a}
        {b c} {c b} {d e} {e d}
        {d f} {f d} {e f} {f e}
    }

    # Build graph as adjacency list (using dictionary)
    set graph [dict create]
    foreach edge $edges {
        set start [lindex $edge 0]
        set end [lindex $edge 1]
        if {[dict exists $graph $start]} {
            set neighbors [dict get $graph $start]
            if {$end ni $neighbors} {
                lappend neighbors $end
                dict set graph $start $neighbors
            }
        } else {
            dict set graph $start [list $end]
        }
    }

    # Initialize current clique, candidates and processed vertices
    set current_clique {}
    set candidates {}
    dict for {vertex neighbors} $graph {
        lappend candidates $vertex
    }
    set processed_vertices {}

    # Execute Bron-Kerbosch algorithm
    bron_kerbosch $current_clique $candidates $processed_vertices $graph

    # Sort cliques for consistent display
    # First sort each clique internally
    set sorted_cliques {}
    foreach clique $cliques {
        set sorted_clique [lsort $clique]
        lappend sorted_cliques $sorted_clique
    }

    # Then sort cliques by lexicographic order
    proc compare_cliques {a b} {
        set len_a [llength $a]
        set len_b [llength $b]
        set min_len [expr {$len_a < $len_b ? $len_a : $len_b}]

        for {set i 0} {$i < $min_len} {incr i} {
            set elem_a [lindex $a $i]
            set elem_b [lindex $b $i]
            if {$elem_a ne $elem_b} {
                return [string compare $elem_a $elem_b]
            }
        }
        return [expr {$len_a - $len_b}]
    }

    set cliques [lsort -command compare_cliques $sorted_cliques]

    # Display the cliques
    print_2D_list $cliques
}

# Run the main procedure
main
