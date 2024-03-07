proc uint32 {n} {
    return [expr {$n & 0xffffffff}]
}

proc uint64 {n} {
    return [expr {$n & 0xffffffffffffffff}]
}

set N 6364136223846793005
set state 0x853c49e6748fea9b
set inc 0xda3e39cb94b95bdb

proc pcg32_seed {seed_state seed_sequence} {
    global state inc
    set state 0
    set inc [expr {($seed_sequence << 1) | 1}]
    pcg32_int
    set state [expr {$state + $seed_state}]
    pcg32_int
}

proc pcg32_int {} {
    global state N inc
    set old $state
    set state [uint64 [expr {$old * $N + $inc}]]
    set shifted [uint32 [expr {(($old >> 18) ^ $old) >> 27}]]
    set rot [uint32 [expr {$old >> 59}]]
    return [uint32 [expr {($shifted >> $rot) | ($shifted << ((~$rot + 1) & 31))}]]
}

proc pcg32_float {} {
    return [expr {1.0 * [pcg32_int] / (1 << 32)}]
}

# -------------------------------------------------------------------

pcg32_seed 42 54
puts [pcg32_int]
puts [pcg32_int]
puts [pcg32_int]
puts [pcg32_int]
puts [pcg32_int]
puts ""

set counts {0 0 0 0 0}
pcg32_seed 987654321 1
for {set i 1} {$i <= 100000} {incr i} {
    set j [expr {int([pcg32_float] * 5.0) + 1}]
    lset counts [expr {$j - 1}] [expr {[lindex $counts [expr {$j - 1}]] + 1}]
}

puts "The counts for 100,000 repetitions are:"
foreach idx {0 1 2 3 4} {
    puts "  $idx: [lindex $counts $idx]"
}
