proc isNumberIntegral {x} {
    expr {$x == entier($x)}
}
# test with various kinds of numbers:
foreach x {1e100 3.14 7 1.000000000000001 1000000000000000000000 -22.7 -123.000} {
    puts [format "%s: %s" $x [expr {[isNumberIntegral $x] ? "yes" : "no"}]]
}
