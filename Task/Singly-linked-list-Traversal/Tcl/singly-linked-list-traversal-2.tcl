set list {}
foreach n {1 3 5 7 2 4 6 8} {
    set list [List new $n $list]
}
$list for x {
    puts "we have a $x in the list"
}
