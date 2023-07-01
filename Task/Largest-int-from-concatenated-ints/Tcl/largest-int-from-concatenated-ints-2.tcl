foreach collection {
    {1 34 3 98 9 76 45 4}
    {54 546 548 60}
} {
    set sorted [intcatsort $collection]
    puts "\[$collection\] => \[$sorted\]  (concatenated: [join $sorted ""])"
}
