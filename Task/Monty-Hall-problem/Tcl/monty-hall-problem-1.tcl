set stay 0; set change 0; set total 10000
for {set i 0} {$i<$total} {incr i} {
    if {int(rand()*3) == int(rand()*3)} {
        incr stay
    } else {
        incr change
    }
}
puts "Estimate: $stay/$total wins for staying strategy"
puts "Estimate: $change/$total wins for changing strategy"
