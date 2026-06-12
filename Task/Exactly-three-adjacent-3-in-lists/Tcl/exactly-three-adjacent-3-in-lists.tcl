#!/usr/bin/env tclsh

# count with a look-ahead regular expression
proc re_matches { l s n } {

    set rgx "(?=($s\ ){$n})"

    set num [regexp -all $rgx  $l]

    return $num
}


set list(1)  {9 3 3 3 2 1 7 8 5}
set list(2)  {5 2 9 3 3 7 8 4 1}
set list(3)  {1 4 3 6 7 3 8 3 2}
set list(4)  {1 2 3 4 5 6 7 8 9}
set list(5)  {4 6 8 7 2 3 3 3 1}
set list(6)  {4 6 8 7 2 3 3 3 3 3 3 1}
set the_lists {}

for {set i 1} { $i <= 6} {incr i} {
    lappend the_lists $list($i)
}

foreach l $the_lists {
    puts -nonewline "$l "

    set num [re_matches $l {3} 3]

    if { $num eq 1 } {
        puts "(true)"
    } elseif { $num > 1 } {
        puts "(false) \[multiple matches\]"
    } else {
        puts "(false)"
    }
}
