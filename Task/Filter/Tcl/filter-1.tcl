set l {56 21 71 27 39 62 87 76 82 94 45 83 65 45 28 90 52 44 1 89}

puts [lmap x $l {if {$x % 2} continue; set x}]
