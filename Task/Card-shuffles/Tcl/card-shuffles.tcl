proc riffle deck {
  set length [llength $deck]
  for {set i 0} {$i < $length/2} { incr i} {
    lappend temp [lindex $deck $i] [lindex $deck [expr {$length/2+$i}]]}
  set temp}
proc overhand deck {
  set cut [expr {[llength $deck] /5}]
  for {set i $cut} {$i >-1} {incr i -1} {
    lappend temp [lrange $deck [expr {$i *$cut}] [expr {($i+1) *$cut -1}] ]}
  concat {*}$temp}
puts [riffle [list 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52]]
puts [overhand [list 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52]]
