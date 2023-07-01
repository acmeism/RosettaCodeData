set v {9 8 7 6 5 0 1 2 3 4}
foreach i {1 2 3 4 5 6 7 8 9 10} {
    puts "$i => [quickselect $v $i]"
}
