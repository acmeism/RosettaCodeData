package require Tcl 8.6; # Just for %b format specifier
for {set i 0} {$i < 32} {incr i} {
    set g [gray::encode $i]
    set b [gray::decode $g]
    puts [format "%2d: %05b => %05b => %05b : %2d" $i $i $g $b $b]
}
