set haystack {Zig Zag Wally Ronald Bush Krusty Charlie Bush Bozo}
foreach needle {Bush Washington} {
    set indices [lsearch -all -exact $haystack $needle]
    if {[llength $indices] == 0} {
        error "$needle does not appear in the haystack"
    } else {
        puts "$needle appears first at index [lindex $indices 0] and last at [lindex $indices end]"
    }
}
