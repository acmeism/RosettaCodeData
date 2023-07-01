namespace eval ::extra_credit {
    variable sum_global_int 0
    variable n_global_int 0
    foreach var [info vars ::*] {
        if {[array exists $var]} continue
        if {[string is int -strict [set $var]]} {
            puts "$var = [set $var]"
            incr sum_global_int [set $var]
            incr n_global_int
        }
    }
    puts "number of global ints = $n_global_int"
    puts "their sum = $sum_global_int"
}
