package require Tcl 8.6

proc rank {integers} {
    join [lmap i $integers {format %llo $i}] 8
}

proc unrank {codedValue} {
    lmap i [split $codedValue 8] {scan $i %llo}
}
