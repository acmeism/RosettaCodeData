proc reverse {str} {
    set rev {}
    set i [string length $str]

    while {$i > 0} {
        incr i -1
       append rev [string index $str $i]
    }
    return [join $rev ""]
}
