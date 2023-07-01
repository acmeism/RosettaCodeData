def count = 15
(1..count).each { n ->
    printf ("%2d:", n); (0..(count-n)).each { print "    " }; pascal(n).each{ printf("%6d  ", it) }; println ""
}
