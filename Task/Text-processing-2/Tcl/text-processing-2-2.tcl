set total [set good 0]
array set seen {}
set fh [open readings.txt]
while {[gets $fh line] != -1} {
    incr total
    set fields [regexp -inline -all {[^ \t\r\n]+} $line]
    if {[llength $fields] != 49} {
        puts "bad format: not 49 fields on line $total"
        continue
    }
    if { ! [regexp {^(\d{4}-\d\d-\d\d)$} [lindex $fields 0] -> date]} {
        puts "bad format: invalid date on line $total: '$date'"
        continue
    }

    if {[info exists seen($date)]} {
        puts "duplicate date on line $total: $date"
    }
    incr seen($date)

    set line_format_ok true
    set readings_ignored 0
    foreach {value flag} [lrange $fields 1 end] {
        if { ! [string is double -strict $value]} {
            puts "bad format: value not a float on line $total: '$value'"
            set line_format_ok false
        }
        if { ! [string is int -strict $flag]} {
            puts "bad format: flag not an integer on line $total: '$flag'"
            set line_format_ok false
        }
        if {$flag < 1} {incr readings_ignored}
    }
    if {$line_format_ok && $readings_ignored == 0} {incr good}
}
close $fh

puts "total: $total"
puts [format "good:  %d = %5.2f%%" $good [expr {100.0 * $good / $total}]]
