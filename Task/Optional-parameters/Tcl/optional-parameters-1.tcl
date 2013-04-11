proc tablesort {table {ordering ""} {column 0} {reverse 0}} {
    set direction [expr {$reverse ? "-decreasing" : "-increasing"}]
    if {$ordering ne ""} {
        lsort -command $ordering $direction -index $column $table
    } else {
        lsort $direction -index $column $table
    }
}

puts [tablesort $data]
puts [tablesort $data "" 1]
puts [tablesort $data "" 0 1]
puts [tablesort $data {
    apply {{a b} {expr {[string length $a]-[string length $b]}}}
}]
