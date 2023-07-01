proc leftfact {n} {
    set s 0
    for {set i [set f 1]} {$i <= $n} {incr i} {
	incr s $f
	set f [expr {$f * $i}]
    }
    return $s
}

for {set i 0} {$i <= 110} {incr i [expr {$i>9?10:1}]} {
    puts "!$i = [leftfact $i]"
}
for {set i 1000} {$i <= 10000} {incr i 1000} {
    puts "!$i has [string length [leftfact $i]] digits"
}
