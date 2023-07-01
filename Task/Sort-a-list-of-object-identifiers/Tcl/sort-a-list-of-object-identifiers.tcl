# Example input data:
set oid_list [list \
                  1.3.6.1.4.1.11.2.17.19.3.4.0.10 \
                  1.3.6.1.4.1.11.2.17.5.2.0.79 \
                  1.3.6.1.4.1.11.2.17.19.3.4.0.4 \
                  1.3.6.1.4.1.11150.3.4.0.1 \
                  1.3.6.1.4.1.11.2.17.19.3.4.0.1 \
                  1.3.6.1.4.1.11150.3.4.0 ]
set oid2_lists [list ]
set dots_max 0
set i 0
foreach oid $oid_list {
    set oid_list [split $oid "."]
    set dot_count [llength $oid_list]
    incr dot_count -1
    if { $dot_count > $dots_max } {
        set dots_max $dot_count
    }
    set dots_arr(${i}) $dot_count
    lappend oid2_lists $oid_list
    incr i
}
# pad for strings of different dot counts
set oid3_lists [list]
for {set ii 0} {$ii < $i} {incr ii} {
    set oid_list [lindex $oid2_lists $ii]
    set add_fields [expr { $dots_max - $dots_arr(${ii}) } ]
    if { $add_fields > 0 } {
        for {set j 0} {$j < $add_fields} {incr j} {
            lappend oid_list -1
        }
    }
    lappend oid3_lists $oid_list
}
for {set n $dots_max} {$n >= 0 } {incr n -1} {
    set oid3_lists [lsort -integer -index $n -increasing $oid3_lists]
}
# unpad strings of different dot counts
set oid4_lists [list]
for {set ii 0} {$ii < $i} {incr ii} {
    set oid_list [lindex $oid3_lists $ii]
    set j [lsearch -exact -integer $oid_list -1]
    if { $j > -1 } {
        set oid2_list [lrange $oid_list 0 ${j}-1]
        lappend oid4_lists $oid2_list
    } else {
        lappend oid4_lists $oid_list
    }
}
foreach oid_list $oid4_lists {
    puts [join $oid_list "."]
}
