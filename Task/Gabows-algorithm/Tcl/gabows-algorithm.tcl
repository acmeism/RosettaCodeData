# Gabow's Algorithm for Strongly Connected Components in Tcl

# Define a simple digraph class using arrays
proc create_digraph {vertex_count} {
    set digraph [dict create]
    dict set digraph vertex_count $vertex_count
    dict set digraph edge_count 0
    dict set digraph adjacency_lists {}

    # Initialize adjacency lists
    for {set i 0} {$i < $vertex_count} {incr i} {
        dict lappend digraph adjacency_lists $i {}
    }

    return $digraph
}

proc add_edge {digraph from to} {
    set vertex_count [dict get $digraph vertex_count]
    if {$from < 0 || $from >= $vertex_count || $to < 0 || $to >= $vertex_count} {
        error "Vertex out of range: $from or $to"
    }

    set adj_lists [dict get $digraph adjacency_lists]
    set from_list [dict get $adj_lists $from]
    dict set adj_lists $from [concat $from_list [list $to]]
    dict set digraph adjacency_lists $adj_lists
    dict incr digraph edge_count

    return $digraph
}

proc get_adjacency_list {digraph vertex} {
    set vertex_count [dict get $digraph vertex_count]
    if {$vertex < 0 || $vertex >= $vertex_count} {
        error "Vertex out of range: $vertex"
    }
    set adj_lists [dict get $digraph adjacency_lists]
    return [dict get $adj_lists $vertex]
}

proc get_vertex_count {digraph} {
    return [dict get $digraph vertex_count]
}

proc digraph_to_string {digraph} {
    set vertex_count [dict get $digraph vertex_count]
    set edge_count [dict get $digraph edge_count]
    set result "Digraph has $vertex_count vertices and $edge_count edges\nAdjacency lists:\n"

    set adj_lists [dict get $digraph adjacency_lists]
    dict for {vertex adj_list} $adj_lists {
        set sorted_list [lsort -integer $adj_list]
        append result [format "%2d: %s\n" $vertex [join $sorted_list " "]]
    }

    return $result
}

# Gabow's SCC Algorithm
proc create_gabow_scc {digraph} {
    set scc [dict create]
    set vertex_count [get_vertex_count $digraph]

    # Initialize data structures
    dict set scc visited {}
    dict set scc component_ids {}
    dict set scc preorders {}
    dict set scc preorder_count 0
    dict set scc scc_count 0
    dict set scc visited_vertices_stack {}
    dict set scc auxiliary_stack {}

    # Initialize arrays
    for {set i 0} {$i < $vertex_count} {incr i} {
        dict lappend scc visited $i 0
        dict lappend scc component_ids $i -1
        dict lappend scc preorders $i -1
    }

    # Run DFS for each unvisited vertex
    for {set vertex 0} {$vertex < $vertex_count} {incr vertex} {
        set visited_list [dict get $scc visited]
        if {[lindex $visited_list $vertex] == 0} {
            set scc [depth_first_search $scc $digraph $vertex]
        }
    }

    return $scc
}

proc depth_first_search {scc digraph vertex} {
    set vertex_count [get_vertex_count $digraph]

    # Mark as visited
    set visited_list [dict get $scc visited]
    set visited_list [lreplace $visited_list $vertex $vertex 1]
    dict set scc visited $visited_list

    # Set preorder
    set preorders_list [dict get $scc preorders]
    set preorder_count [dict get $scc preorder_count]
    set preorders_list [lreplace $preorders_list $vertex $vertex $preorder_count]
    dict set scc preorders $preorders_list
    dict incr scc preorder_count

    # Push to stacks
    set visited_stack [dict get $scc visited_vertices_stack]
    set aux_stack [dict get $scc auxiliary_stack]
    set visited_stack [concat $visited_stack [list $vertex]]
    set aux_stack [concat $aux_stack [list $vertex]]
    dict set scc visited_vertices_stack $visited_stack
    dict set scc auxiliary_stack $aux_stack

    # Process adjacent vertices
    set adj_list [get_adjacency_list $digraph $vertex]
    foreach w $adj_list {
        set visited_list [dict get $scc visited]
        set component_ids_list [dict get $scc component_ids]

        if {[lindex $visited_list $w] == 0} {
            set scc [depth_first_search $scc $digraph $w]
        } elseif {[lindex $component_ids_list $w] == -1} {
            # Pop from auxiliary stack while needed
            set preorders_list [dict get $scc preorders]
            set aux_stack [dict get $scc auxiliary_stack]
            while {[llength $aux_stack] > 0} {
                set top [lindex $aux_stack end]
                set top_preorder [lindex $preorders_list $top]
                set w_preorder [lindex $preorders_list $w]
                if {$top_preorder <= $w_preorder} {
                    break
                }
                set aux_stack [lrange $aux_stack 0 end-1]
            }
            dict set scc auxiliary_stack $aux_stack
        }
    }

    # Check if vertex is SCC root
    set aux_stack [dict get $scc auxiliary_stack]
    if {[llength $aux_stack] > 0 && [lindex $aux_stack end] == $vertex} {
        # Pop from auxiliary stack
        set aux_stack [lrange $aux_stack 0 end-1]
        dict set scc auxiliary_stack $aux_stack

        # Assign component IDs
        set component_ids_list [dict get $scc component_ids]
        set visited_stack [dict get $scc visited_vertices_stack]
        set scc_count [dict get $scc scc_count]

        while {[llength $visited_stack] > 0} {
            set w [lindex $visited_stack end]
            set visited_stack [lrange $visited_stack 0 end-1]
            set component_ids_list [lreplace $component_ids_list $w $w $scc_count]
            if {$w == $vertex} {
                break
            }
        }

        dict set scc component_ids $component_ids_list
        dict set scc visited_vertices_stack $visited_stack
        dict incr scc scc_count
    }

    return $scc
}

proc get_components {scc vertex_count} {
    set scc_count [dict get $scc scc_count]
    set components {}

    # Initialize component lists
    for {set i 0} {$i < $scc_count} {incr i} {
        lappend components {}
    }

    # Populate components
    set component_ids_list [dict get $scc component_ids]
    for {set vertex 0} {$vertex < $vertex_count} {incr vertex} {
        set component_id [lindex $component_ids_list $vertex]
        if {$component_id != -1} {
            set comp_list [lindex $components $component_id]
            set comp_list [concat $comp_list [list $vertex]]
            set components [lreplace $components $component_id $component_id $comp_list]
        } else {
            error "Warning: Vertex $vertex has no SCC ID assigned."
        }
    }

    return $components
}

proc is_strongly_connected {scc v w} {
    set component_ids_list [dict get $scc component_ids]
    set v_id [lindex $component_ids_list $v]
    set w_id [lindex $component_ids_list $w]
    return [expr {$v_id != -1 && $v_id == $w_id}]
}

proc get_component_id {scc vertex} {
    set component_ids_list [dict get $scc component_ids]
    return [lindex $component_ids_list $vertex]
}

proc get_scc_count {scc} {
    return [dict get $scc scc_count]
}

# Main execution
proc main {} {
    # Create edges
    set edges {
        {4 2} {2 3} {3 2} {6 0} {0 1}
        {2 0} {11 12} {12 9} {9 10} {9 11} {8 9}
        {10 12} {0 5} {5 4} {3 5} {6 4} {6 9}
        {7 6} {7 8} {8 7} {5 3} {0 6}
    }

    # Create digraph
    set digraph [create_digraph 13]

    # Add edges
    foreach edge $edges {
        set from [lindex $edge 0]
        set to [lindex $edge 1]
        set digraph [add_edge $digraph $from $to]
    }

    puts "Constructed digraph:"
    puts [digraph_to_string $digraph]

    # Run Gabow's algorithm
    set gabow_scc [create_gabow_scc $digraph]
    set scc_count [get_scc_count $gabow_scc]
    puts "It has $scc_count strongly connected components."

    # Get components
    set components [get_components $gabow_scc 13]
    puts "\nComponents:"
    for {set i 0} {$i < [llength $components]} {incr i} {
        set component [lindex $components $i]
        puts "Component $i: [join $component " "]"
    }

    # Example connectivity checks
    puts "\nExample connectivity checks:"
    puts "Vertices 0 and 3 strongly connected? [is_strongly_connected $gabow_scc 0 3]"
    puts "Vertices 0 and 7 strongly connected? [is_strongly_connected $gabow_scc 0 7]"
    puts "Vertices 9 and 12 strongly connected? [is_strongly_connected $gabow_scc 9 12]"
    puts "Component ID of vertex 5: [get_component_id $gabow_scc 5]"
    puts "Component ID of vertex 8: [get_component_id $gabow_scc 8]"
}

# Run the main procedure
main
