proc binarySearch {lst x} {
    set idx [lsearch -sorted -exact $lst $x]
    if {$idx == -1} {
        puts "element $x not found in list"
    } else {
        puts "element $x found at index $idx"
    }
}
