package require Tcl 8.5

set keys   [list fred bob joe]
set values [list barber plumber tailor]

foreach a $keys b $values {
    dict set jobs $a $b
}

puts "jobs: [dict get $jobs]"
