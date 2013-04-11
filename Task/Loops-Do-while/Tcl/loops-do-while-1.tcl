proc do {body keyword expression} {
    if {$keyword eq "while"} {
       set expression "!($expression)"
    } elseif {$keyword ne "until"} {
       return -code error "unknown keyword \"$keyword\": must be until or while"
    }
    set condition [list expr $expression]
    while 1 {
       uplevel 1 $body
       if {[uplevel 1 $condition]} {
          break
       }
    }
    return
}

set i 0
do {puts [incr i]} while {$i % 6 != 0}
