while {[incr i] < 101} {
    set fb [if {$i % 3 == 0} {list Fizz}][if {$i % 5 == 0} {list Buzz}]
    if {$fb ne ""} {puts $fb} {puts $i}
}
