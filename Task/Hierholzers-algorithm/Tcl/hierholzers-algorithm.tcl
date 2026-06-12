proc print_circuit {adjacency_list} {
    # Check if adjacency list is empty
    if {[llength $adjacency_list] == 0} {
        return
    }

    set path {}
    set circuit {}
    set current_vertex 0  ;# Tcl lists are 0-based

    # Add current vertex to path
    lappend path $current_vertex

    while {[llength $path] > 0} {
        # Get the adjacency list for current vertex
        set current_adj_list [lindex $adjacency_list $current_vertex]

        if {[llength $current_adj_list] > 0} {
            # Add current vertex to path
            lappend path $current_vertex
            # Remove and get the first element from adjacency list
            set next_vertex [lindex $current_adj_list 0]
            set current_adj_list [lreplace $current_adj_list 0 0]
            # Update the adjacency list in the main list
            set adjacency_list [lreplace $adjacency_list $current_vertex $current_vertex $current_adj_list]
            set current_vertex $next_vertex
        } else {
            # Add current vertex to circuit
            lappend circuit $current_vertex
            # Remove and get the last element from path
            set current_vertex [lindex $path end]
            set path [lreplace $path end end]
        }
    }

    # Print the circuit in reverse order
    set circuit_length [llength $circuit]
    for {set i [expr {$circuit_length - 1}]} {$i >= 0} {incr i -1} {
        puts -nonewline [lindex $circuit $i]
        if {$i != 0} {
            puts -nonewline " => "
        }
    }
    puts ""
}

# Test cases
set adjacency_list1 {{1} {2} {0}}

print_circuit $adjacency_list1

set adjacency_list2 {{1 6} {2} {0 3} {4} {2 5} {0} {4}}

print_circuit $adjacency_list2
