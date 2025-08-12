set p ""
set q {}
set n 0
puts [expr {$p eq {}? true : false}]
puts [expr {$p eq ""? true : false}]
puts [expr {$p eq $q? true : false}]
puts [expr {$p eq 0?  true : false}]
