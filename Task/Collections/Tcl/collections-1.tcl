set c [list] ;# create an empty list
# fill it
lappend c 10 11 13
set c [linsert $c 2 "twelve goes here"]
# iterate over it
foreach elem $c {puts $elem}

# pass to a proc
proc show_size {l} {
    puts [llength $l]
}
show_size $c
