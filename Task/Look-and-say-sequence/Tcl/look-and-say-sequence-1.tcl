proc lookandsay n {
    set new ""
    while {[string length $n] > 0} {
        set char [string index $n 0]
        for {set count 1} {[string index $n $count] eq $char} {incr count} {}
        append new $count $char
        set n [string range $n $count end]
    }
    interp alias {} next_lookandsay {} lookandsay $new
    return $new
}

puts 1                 ;# ==> 1
puts [lookandsay 1]    ;# ==> 11
puts [next_lookandsay] ;# ==> 21
puts [next_lookandsay] ;# ==> 1211
puts [next_lookandsay] ;# ==> 111221
puts [next_lookandsay] ;# ==> 312211
