namespace path longfloat
for {set n -7; set e 63} {$n <= 21} {incr n;incr e -9} {
    append m 012345679
    puts $n:[+ [* [format "%se%s" $m $e] 81] 1e${e}]
}
