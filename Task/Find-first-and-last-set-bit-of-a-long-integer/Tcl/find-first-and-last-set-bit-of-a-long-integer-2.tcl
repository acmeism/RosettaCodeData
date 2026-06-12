package require Tcl 8.6; # For convenient bit string printing

proc powsTo {pow bits} {
    set result {}
    for {set n 1} {$n < 2**$bits} {set n [expr {$n * $pow}]} {
	lappend result $n
    }
    return $result
}
proc printPows {pow pows} {
    set len [string length [lindex $pows end]]
    puts [format "%8s | %*s | LWB | UPB | Bits" "What" $len "Number"]
    set n 0
    foreach p $pows {
	puts [format "%4d**%-2d = %*lld | %3d | %3d | %b" \
		  $pow $n $len $p [lwb $p] [upb $p] $p]
	incr n
    }
}

puts "Powers of 42 up to machine word size:"
printPows 42 [powsTo 42 [expr {$tcl_platform(wordSize) * 8}]]
puts "Powers of 1302 up to 128 bits"
printPows 1302 [powsTo 1302 128]
