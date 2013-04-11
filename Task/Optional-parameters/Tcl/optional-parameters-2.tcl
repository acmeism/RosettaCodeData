package require Tcl 8.5;  # Only for the list expansion syntax

proc tablesort {table args} {
    array set opt {ordering "" column 0 reverse 0}
    array set opt $args
    set pars [list -index $opt(column)]
    if {$opt(reverse)} {lappend pars -decreasing}
    if {$opt(ordering) ne ""} {lappend pars -command $opt(ordering)}
    lsort {*}$pars $table
}

puts [tablesort $data]
puts [tablesort $data column 1]
puts [tablesort $data column 0]
puts [tablesort $data column 0 reverse 1]
puts [tablesort $data ordering {
    apply {{a b} {expr {[string length $b]-[string length $a]}}}
}]
