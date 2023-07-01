lassign $argv head
while { [gets stdin line] >= 0 } {
    foreach word [regexp -all -inline {[A-Za-z]+} $line] {
        dict incr wordcount [string tolower $word]
    }
}

set sorted [lsort -stride 2 -index 1 -int -decr $wordcount]
foreach {word count} [lrange $sorted 0 [expr {$head * 2 - 1}]] {
    puts "$count\t$word"
}
