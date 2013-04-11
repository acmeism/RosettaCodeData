package require Tcl 8.5

proc vlqEncode number {
    if {$number < 0} {error "negative not supported"}
    while 1 {
	lappend digits [expr {$number & 0x7f}]
	if {[set number [expr {$number >> 7}]] == 0} break
    }
    set out [format %c [lindex $digits 0]]
    foreach digit [lrange $digits 1 end] {
	set out [format %c%s [expr {0x80+$digit}] $out]
    }
    return $out
}
proc vlqDecode chars {
    set n 0
    foreach c [split $chars ""] {
	scan $c %c c
	set n [expr {($n<<7) | ($c&0x7f)}]
	if {!($c&0x80)} break
    }
    return $n
}
