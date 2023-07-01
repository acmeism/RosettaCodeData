package require Tcl 8.5
proc palindrome {s} {
    return [expr {$s eq [string reverse $s]}]
}
