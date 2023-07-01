proc ::tcl::mathfunc::mulinv {a b} {
    if {$b == 1} {return 1}
    set b0 $b; set x0 0; set x1 1
    while {$a > 1} {
	set x0 [expr {$x1 - ($a / $b) * [set x1 $x0]}]
	set b [expr {$a % [set a $b]}]
    }
    incr x1 [expr {($x1 < 0) * $b0}]
}
proc chineseRemainder {nList aList} {
    set sum 0; set prod [::tcl::mathop::* {*}$nList]
    foreach n $nList a $aList {
	set p [expr {$prod / $n}]
	incr sum [expr {$a * mulinv($p, $n) * $p}]
    }
    expr {$sum % $prod}
}
puts [chineseRemainder {3 5 7} {2 3 2}]
