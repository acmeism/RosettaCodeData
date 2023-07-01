proc multisplit {text sep} {
    foreach s $sep {lappend sr [regsub -all {\W} $s {\\&}]}
    set sepRE [join $sr "|"]
    set pieces {}
    set match {}
    set start 0
    while {[regexp -indices -start $start -- $sepRE $text found]} {
	lassign $found x y
	lappend pieces [string range $text $start [expr {$x-1}]]
	lappend match [lsearch -exact $sep [string range $text {*}$found]] $x
	set start [expr {$y + 1}]
    }
    return [list [lappend pieces [string range $text $start end]] $match]
}
