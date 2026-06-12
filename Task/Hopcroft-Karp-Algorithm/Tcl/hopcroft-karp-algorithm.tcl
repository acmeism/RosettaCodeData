#!/usr/bin/env tclsh

# Representation of a bipartite graph
# Vertices in the left partition, U, are numbered from 1 to m,
# and vertices in the right partition, V, are numbered 1 to n.

namespace eval BipartiteGraph {
    namespace export new add_edge hopcroft_karp_algorithm
}

proc BipartiteGraph::new {m n} {
    set self [dict create]
    dict set self m $m
    dict set self n $n
    dict set self adjacency_lists [dict create]
    dict set self pair_u [dict create]
    dict set self pair_v [dict create]
    dict set self levels [dict create]
    dict set self NIL 0
    dict set self INFINITY 999999999

    # Initialize adjacency lists
    for {set u 1} {$u <= $m} {incr u} {
        dict set self adjacency_lists $u [list]
    }

    # Initialize pairs
    for {set u 1} {$u <= $m} {incr u} {
        dict set self pair_u $u [dict get $self NIL]
    }
    for {set v 1} {$v <= $n} {incr v} {
        dict set self pair_v $v [dict get $self NIL]
    }

    # Initialize levels
    for {set u 1} {$u <= $m} {incr u} {
        dict set self levels $u [dict get $self INFINITY]
    }

    return $self
}

proc BipartiteGraph::add_edge {self_ref u v} {
    upvar $self_ref self

    set m [dict get $self m]
    set n [dict get $self n]

    if {$u >= 1 && $u <= $m && $v >= 1 && $v <= $n} {
        set adj_lists [dict get $self adjacency_lists]
        set u_list [dict get $adj_lists $u]
        lappend u_list $v
        dict set adj_lists $u $u_list
        dict set self adjacency_lists $adj_lists
    } else {
        error "Attempt to add an edge ($u, $v) which is out of bounds"
    }
}

# Return the matching size of the bipartite graph
proc BipartiteGraph::hopcroft_karp_algorithm {self_ref} {
    upvar $self_ref self

    set m [dict get $self m]
    set n [dict get $self n]
    set NIL [dict get $self NIL]
    set INFINITY [dict get $self INFINITY]

    # Reset pairs
    for {set u 1} {$u <= $m} {incr u} {
        dict set self pair_u $u $NIL
    }
    for {set v 1} {$v <= $n} {incr v} {
        dict set self pair_v $v $NIL
    }

    set matching_size 0

    while {[breadth_first_search self]} {
        for {set u 1} {$u <= $m} {incr u} {
            set pair_u_dict [dict get $self pair_u]

            if {[dict get $pair_u_dict $u] == $NIL && [depth_first_search self $u]} {
                # vertex u is free and an augmenting path starting
                # from u has been found by the depth first search
                incr matching_size
            }
        }
    }

    return $matching_size
}

# Determines whether there exists an augmenting path starting from a free vertex in U.
# Return true if an augmenting path could exist, otherwise false.
proc BipartiteGraph::breadth_first_search {self_ref} {
    upvar $self_ref self

    set m [dict get $self m]
    set n [dict get $self n]
    set NIL [dict get $self NIL]
    set INFINITY [dict get $self INFINITY]

    set queue [list]

    # Initialize 'levels' for the vertices in U
    for {set u 1} {$u <= $m} {incr u} {
        set pair_u_dict [dict get $self pair_u]

        if {[dict get $pair_u_dict $u] == $NIL} {
            # If u is a free vertex, its level is 0 and it is added to the queue
            dict set self levels $u 0
            lappend queue $u
        } else {
            # Otherwise, set 'levels' to infinity
            dict set self levels $u $INFINITY
        }
    }

    # The 'level' to the NIL node represents the length of the shortest augmenting path
    dict set self levels $NIL $INFINITY

    while {[llength $queue] > 0} {
        set u [lindex $queue 0]
        set queue [lrange $queue 1 end]

        set levels_dict [dict get $self levels]
        if {[dict get $levels_dict $u] < [dict get $levels_dict $NIL]} {
            # The path through u could lead to a shorter augmenting path
            set adj_lists [dict get $self adjacency_lists]
            set u_list [dict get $adj_lists $u]
            set pair_v_dict [dict get $self pair_v]

            foreach v $u_list {
                # Explore the neighbours v of u in V
                set matched_u [dict get $pair_v_dict $v]
                set levels_dict [dict get $self levels]
                if {[dict get $levels_dict $matched_u] == $INFINITY} {
                    # The matched vertex has not been visited yet
                    dict set self levels $matched_u [expr {[dict get $levels_dict $u] + 1}]
                    lappend queue $matched_u ;# Enqueue the matched vertex to explore it further
                }
            }
        }
    }

    # An augmenting path from the initial free vertices was found if levels[NIL] is not INFINITY
    set levels_dict [dict get $self levels]
    return [expr {[dict get $levels_dict $NIL] != $INFINITY}]
}

# Determine whether the shortest path from vertex u in U found by breadth_first_search() can be augmented.
# Return true if an augmenting path was found starting from u, otherwise false.
proc BipartiteGraph::depth_first_search {self_ref u} {
    upvar $self_ref self

    set NIL [dict get $self NIL]
    set INFINITY [dict get $self INFINITY]

    if {$u != $NIL} {
        set adj_lists [dict get $self adjacency_lists]
        set u_list [dict get $adj_lists $u]
        set pair_v_dict [dict get $self pair_v]
        set levels_dict [dict get $self levels]

        foreach v $u_list {
            # Explore neighbours v of u in V
            set matched_u [dict get $pair_v_dict $v]
            # Check whether the edge (u, v) leads to a vertex matched_u
            # such that the path u -> v -> matched_u is part of a shortest augmenting path
            if {[dict get $levels_dict $matched_u] == [expr {[dict get $levels_dict $u] + 1}]} {
                if {[depth_first_search self $matched_u]} {
                    # An augmenting path is found starting from 'matched_u'
                    dict set self pair_v $v $u ;# Match v with u,
                    dict set self pair_u $u $v ;# and u with v
                    return 1
                }
            }
        }

        # No augmenting path was found starting from vertex u through any of its neighbours v,
        # so remove u from the depth first search phase of the algorithm
        dict set self levels $u $INFINITY
        return 0
    }

    return 1
}

proc test_value {test_number m n edges expected_result} {
    set graph [BipartiteGraph::new $m $n]

    foreach edge $edges {
        set from_val [dict get $edge from]
        set to_val [dict get $edge to]
        BipartiteGraph::add_edge graph $from_val $to_val
    }

    set result [BipartiteGraph::hopcroft_karp_algorithm graph]
    puts "Test $test_number: Result = $result, Expected = $expected_result"

    if {$result == $expected_result} {
        return 1
    }

    puts "Test $test_number failed."
    return 0
}

# Main execution
puts "Running tests:"
set success_count 0

# Test Case 1
set edges1 [list [dict create from 1 to 4]]
incr success_count [test_value 1 3 5 $edges1 1]

# Test Case 2
set edges2 [list \
    [dict create from 1 to 4] \
    [dict create from 1 to 5] \
    [dict create from 5 to 1] \
]
incr success_count [test_value 2 6 6 $edges2 2]

# Test Case 3: Complete Bipartite Graph K(3, 3)
set edges3 [list]
for {set i 1} {$i <= 3} {incr i} {
    for {set j 1} {$j <= 3} {incr j} {
        lappend edges3 [dict create from $i to $j]
    }
}
incr success_count [test_value 3 3 3 $edges3 3]

# Test Case 4: No edges
incr success_count [test_value 4 2 2 [list] 0]

# Test Case 5
set edges5 [list \
    [dict create from 1 to 1] \
    [dict create from 1 to 3] \
    [dict create from 2 to 3] \
    [dict create from 3 to 4] \
    [dict create from 4 to 3] \
    [dict create from 4 to 2] \
]
incr success_count [test_value 5 4 4 $edges5 4]

if {$success_count == 5} {
    puts "All tests passed."
}
