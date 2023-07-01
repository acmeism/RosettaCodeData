package require Tcl 8.6;  # For easy scanning of binary

# The strings to parse
set dec1 "0123459"
set hex2 "abcf123"
set oct3 "7651"
set bin4 "101011001"

# Parse the numbers
scan $dec1 "%d" v1
scan $hex2 "%x" v2
scan $oct3 "%o" v3
scan $bin4 "%b" v4; # Only 8.6-specific operation; others work in all versions

# Print out what happened
puts "$dec1->$v1 $hex2->$v2 $oct3->$v3 $bin4->$v4"
