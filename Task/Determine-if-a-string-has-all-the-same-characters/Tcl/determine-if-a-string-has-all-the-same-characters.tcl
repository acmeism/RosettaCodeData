package require Tcl 8.6 ; # For binary encode

array set yesno {1 Yes 0 No}

set test {
    {}
    {   }
    {2}
    {333}
    {.55}
    {tttTTT}
    {4444 444k}
    {jjjjjjj}
}

# Loop through test strings
foreach str $test {
    set chars [dict create] ; # init dictionary
    set same 1
    set prev {}
    # Loop through characters in string
    for {set i 0} {$i < [string length $str]} {incr i} {
        set c [string index $str $i] ; # get char at index
        if {$prev == {}} {
            set prev $c ; # initialize prev if it doesn't exist
        }
        if {$c != $prev} {
            set same 0
            break ; # Found a different char, break out of the loop
        }
    }

    # Handle Output
    puts [format "Tested: %12s (len: %2d). All Same? %3s. " \
              "'$str'" [string length $str] $yesno($same)]
    if {! $same} {
        puts [format " --> Different character '%s' (hex: 0x%s) appears at index: %s." \
                  $c [binary encode hex $c] $i]
    }
}
