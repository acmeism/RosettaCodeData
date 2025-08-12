proc multiply { a b args } {

    set product 1

    foreach m [list $a $b {*}$args] {

	    set product [expr {$product * $m}]
    }

    return $product
}

puts stdout [multiply  3 4 7 9 -2 -5 ]
