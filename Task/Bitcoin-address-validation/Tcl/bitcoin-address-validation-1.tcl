package require sha256

# Generate a large and boring piece of code to do the decoding of
# base58-encoded data.
apply {{} {
    set chars "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
    set i -1
    foreach c [split $chars ""] {
	lappend map $c "return -level 0 [incr i]"
    }
    lappend map default {return -code error "bad character \"$c\""}
    proc base58decode str [string map [list @BODY@ [list $map]] {
	set num 0
	set count [expr {ceil(log(58**[string length $str])/log(256))}]
	foreach c [split $str {}] {
	    set num [expr {$num*58+[switch $c @BODY@]}]
	}
	for {set i 0} {$i < $count} {incr i} {
	    append result [binary format c [expr {$num & 255}]]
	    set num [expr {$num >> 8}]
	}
	return [string reverse $result]
    }]
}}

# How to check bitcoin address validity
proc bitcoin_addressValid {address} {
    set a [base58decode $address]
    set ck [sha2::sha256 -bin [sha2::sha256 -bin [string range $a 0 end-4]]]
    if {[string range $a end-3 end] ne [string range $ck 0 3]} {
	return -code error "signature does not match"
    }
    return "$address is ok"
}
