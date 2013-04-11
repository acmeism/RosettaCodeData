proc intcatsort {nums} {
    lsort -command {apply {{x y} {expr {"$y$x" - "$x$y"}}}} $nums
}
