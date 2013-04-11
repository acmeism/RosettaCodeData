package require control
set i 0; control::do {puts [incr i]} while {$i % 6 != 0}
set i 0; control::do {puts [incr i]} until {$i % 6 == 0}
