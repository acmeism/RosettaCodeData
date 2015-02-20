package require ripemd160
package require sha256

# Exactly the algorithm from https://en.bitcoin.it/wiki/Base58Check_encoding
proc base58encode data {
    set digits "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
    for {set zeroes 0} {[string index $data 0] eq "\x00"} {incr zeroes} {
	set data [string range $data 1 end]
    }
    binary scan $data "H*" hex
    scan $hex "%llx" num
    for {set out ""} {$num > 0} {set num [expr {$num / 58}]} {
	append out [string index $digits [expr {$num % 58}]]
    }
    append out [string repeat [string index $digits 0] $zeroes]
    return [string reverse $out]
}

# Encode a Bitcoin address
proc bitcoin_mkaddr {A B} {
    set A [expr {$A & ((1<<256)-1)}]
    set B [expr {$B & ((1<<256)-1)}]
    set bin [binary format "cH*" 4 [format "%064llx%064llx" $A $B]]
    set md [ripemd::ripemd160 [sha2::sha256 -bin $bin]]
    set addr [binary format "ca*" 0 $md]
    set hash [sha2::sha256 -bin [sha2::sha256 -bin $addr]]
    append addr [binary format "a4" [string range $hash 0 3]]
    return [base58encode $addr]
}
