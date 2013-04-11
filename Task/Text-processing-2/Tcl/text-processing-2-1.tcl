set data [lrange [split [read [open "readings.txt" "r"]] "\n"] 0 end-1]
set total [llength $data]
set correct $total
set datestamps {}

foreach line $data {
    set formatOk true
    set hasAllMeasurements true

    set date [lindex $line 0]
    if {[llength $line] != 49} { set formatOk false }
    if {![regexp {\d{4}-\d{2}-\d{2}} $date]} { set formatOk false }
    if {[lsearch $datestamps $date] != -1} { puts "Duplicate datestamp: $date" } {lappend datestamps $date}

    foreach {value flag} [lrange $line 1 end] {
        if {$flag < 1} { set hasAllMeasurements false }

        if {![regexp -- {[-+]?\d+\.\d+} $value] || ![regexp -- {-?\d+} $flag]} {set formatOk false}
    }
    if {!$hasAllMeasurements} { incr correct -1 }
    if {!$formatOk} { puts "line \"$line\" has wrong format" }
}

puts "$correct records with good readings = [expr $correct * 100.0 / $total]%"
puts "Total records: $total"
