package require Tcl 8.6 ; # For binary encode

array set yesno {1 Yes 2 No}

set test {
    {}
    {.}
    {abcABC}
    {XYZ ZYX}
    {1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ}
    {hétérogénéité}
}

# Loop through test strings
foreach str $test {
    set chars [dict create] ; # init dictionary
    set num_chars 1 ; # In case of empty string

    # Loop through characters in string
    for {set i 0} {$i < [string length $str]} {incr i} {
        set c [string index $str $i] ; # get char at index
        dict lappend chars $c $i ; # add index to a running list for key=char
        set indexes [dict get $chars $c] ; # get the whole running list
        set num_chars [llength $indexes] ; # count the # of indexes
        if {$num_chars > 1} {
            break ; # Found a duplicate, break out of the loop
        }
    }

    # Handle Output
    puts [format "Tested: %38s (len: %2d). All unique? %3s. " \
              "'$str'" [string length $str] $yesno($num_chars)]
    if {$num_chars > 1} {
        puts [format " --> Character '%s' (hex: 0x%s) reappears at indexes: %s." \
                  $c [binary encode hex $c] $indexes]
    }
}
