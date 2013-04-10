# Create in bulk
set d [dict create  foo 5  bar 10  baz 15]

# Create/update one element
dict set d foo 5

# Access one value
set value [dict get $d foo]

# Output all values
dict for {key value} $d {
    puts $value
}
# Alternatively...
foreach value [dict values $d] {
    puts $value
}

# Output the whole dictionary (since it is a Tcl value itself)
puts $d
