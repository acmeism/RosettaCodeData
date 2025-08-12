proc leq {strings} {

    set s [lindex $strings 0] ; # first string

    foreach str $strings {
	   if { ! $s eq $str } { return 0 }
    }
    return 1
}


# compares strings lexicographically by default
proc strict_increasing { strings } {

    set a 0

    foreach s  $strings {
	  if {$s < $a} {return 0}
	  set a $s
    }

    return 1
}
