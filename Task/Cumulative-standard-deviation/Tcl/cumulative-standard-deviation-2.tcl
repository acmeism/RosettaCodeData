# Make a coroutine out of a lambda application
coroutine sd apply {{} {
    set sum 0.0
    set sum2 0.0
    set sd {}
    # Keep processing argument values until told not to...
    while {[set val [yield $sd]] ne "stop"} {
        incr n
        set sum [expr {$sum + $val}]
        set sum2 [expr {$sum2 + $val**2}]
        set sd [expr {sqrt($sum2/$n - ($sum/$n)**2)}]
    }
}}

# Demonstration
foreach val {2 4 4 4 5 5 7 9} {
    set sd [sd $val]
}
sd stop
puts "the standard deviation is: $sd"
