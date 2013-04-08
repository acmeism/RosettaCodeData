set haystack {Zig Zag Wally Ronald Bush Krusty Charlie Bush Bozo}
foreach needle {Bush Washington} {
    if {[set idx [lsearch -exact $haystack $needle]] == -1} {
        error "$needle does not appear in the haystack"
    } else {
        puts "$needle appears at index $idx in the haystack"
    }
}
