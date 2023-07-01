set results [carmichael 61 2]
puts "[expr {[llength $results]/4}] Carmichael numbers found"
foreach {p1 p2 p3 c} $results {
    puts "$p1 x $p2 x $p3 = $c"
}
