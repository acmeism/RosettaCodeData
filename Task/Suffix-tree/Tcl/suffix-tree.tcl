#!/usr/bin/tclsh

# Node class implementation
proc Node_new {} {
    return [dict create sub "" ch [list]]
}

# SuffixTree class implementation
proc SuffixTree_new {str} {
    set self [dict create nodes [list]]

    # Add root node
    dict lappend self nodes [Node_new]

    # Add all suffixes
    set len [string length $str]
    for {set i 0} {$i < $len} {incr i} {
        set suffix [string range $str $i end]
        set self [SuffixTree_addSuffix $self $suffix]
    }

    return $self
}

proc SuffixTree_addSuffix {self suf} {
    set nodes [dict get $self nodes]
    set n 0
    set i 0
    set suf_len [string length $suf]

    while {$i < $suf_len} {
        set b [string index $suf $i]
        set current_node [lindex $nodes $n]
        set children [dict get $current_node ch]
        set x2 0
        set n2 -1

        # Find matching child
        set found 0
        foreach child_idx $children {
            set child_node [lindex $nodes $child_idx]
            set child_sub [dict get $child_node sub]
            if {[string index $child_sub 0] eq $b} {
                set n2 $child_idx
                set found 1
                break
            }
            incr x2
        }

        if {!$found} {
            # No matching child, remainder of suf becomes new node
            set n2 [llength $nodes]
            set temp [Node_new]
            dict set temp sub [string range $suf $i end]
            lappend nodes $temp

            # Update parent's children list
            set parent_node [lindex $nodes $n]
            set parent_children [dict get $parent_node ch]
            lappend parent_children $n2
            dict set parent_node ch $parent_children
            lset nodes $n $parent_node

            dict set self nodes $nodes
            return $self
        }

        # Find prefix of remaining suffix in common with child
        set child_node [lindex $nodes $n2]
        set sub2 [dict get $child_node sub]
        set j 0
        set sub2_len [string length $sub2]

        while {$j < $sub2_len} {
            if {[string index $suf [expr {$i + $j}]] ne [string index $sub2 $j]} {
                # Split n2
                set n3 $n2
                # New node for the part in common
                set n2 [llength $nodes]
                set temp [Node_new]
                dict set temp sub [string range $sub2 0 [expr {$j - 1}]]
                dict set temp ch [list $n3]
                lappend nodes $temp

                # Old node loses the part in common
                set old_node [lindex $nodes $n3]
                dict set old_node sub [string range $sub2 $j end]
                lset nodes $n3 $old_node

                # Update parent's child reference
                set parent_node [lindex $nodes $n]
                set parent_children [dict get $parent_node ch]
                lset parent_children $x2 $n2
                dict set parent_node ch $parent_children
                lset nodes $n $parent_node

                break
            }
            incr j
        }

        incr i $j  ;# advance past part in common
        set n $n2  ;# continue down the tree
    }

    dict set self nodes $nodes
    return $self
}

proc SuffixTree_visualize {self} {
    set nodes [dict get $self nodes]

    if {[llength $nodes] == 0} {
        puts "<empty>"
        return
    }
    SuffixTree_visualize_f $self 0 ""
}

proc SuffixTree_visualize_f {self n pre} {
    set nodes [dict get $self nodes]
    set current_node [lindex $nodes $n]
    set children [dict get $current_node ch]
    set node_sub [dict get $current_node sub]

    if {[llength $children] == 0} {
        puts "- $node_sub"
        return
    }

    puts "┐ $node_sub"

    set children_count [llength $children]
    for {set i 0} {$i < [expr {$children_count - 1}]} {incr i} {
        set c [lindex $children $i]
        puts -nonewline "${pre}├─"
        SuffixTree_visualize_f $self $c "${pre}│ "
    }

    puts -nonewline "${pre}└─"
    set last_child [lindex $children end]
    SuffixTree_visualize_f $self $last_child "${pre}  "
}

# Main execution
set tree [SuffixTree_new "banana\$"]
SuffixTree_visualize $tree
