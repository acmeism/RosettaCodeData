set alpha [apply {{} {
    scan "az" "%c%c" from to
    for {set i $from} {$i <= $to} {incr i} {
        lappend l [format "%c" $i]
    }
    return $l
}}]
