puts "Number: MP MDR"
puts [regsub -all . "Number: MP MDR" -]
foreach n {123321 7739 893 899998} {
    puts [format "%6d: %2d %3d" $n {*}[mdr $n]]
}
puts ""
# The longEnough variable counts how many roots have at least 5 values accumulated for them
for {set i [set longEnough 0]} {$longEnough < 10} {incr i} {
    set root [lindex [mdr $i] 1]
    if {[llength [lappend accum($root) $i]] == 5} {incr longEnough}
}
puts "MDR: \[n\u2080\u2026n\u2084\]"
puts [regsub -all . "MDR: \[n\u2080\u2026n\u2084\]" -]
for {set i 0} {$i < 10} {incr i} {
    puts [format "%3d: (%s)" $i [join [lrange $accum($i) 0 4] ", "]]
}
