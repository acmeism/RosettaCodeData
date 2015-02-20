package require Tcl 8.5

# This is a straight-forward square-and-multiply implementation that relies on
# Tcl 8.5's bignum support (based on LibTomMath) for speed.
proc modexp {b expAndMod} {
    lassign $expAndMod -> e n
    if {$b >= $n} {puts stderr "WARNING: modulus too small"}
    for {set r 1} {$e != 0} {set e [expr {$e >> 1}]} {
	if {$e & 1} {
	    set r [expr {($r * $b) % $n}]
	}
	set b [expr {($b ** 2) % $n}]
    }
    return $r
}

# Assumes that messages are shorter than the modulus
proc rsa_encrypt {message publicKey} {
    if {[lindex $publicKey 0] ne "publicKey"} {error "key handling"}
    set toEnc 0
    foreach char [split [encoding convertto utf-8 $message] ""] {
	set toEnc [expr {$toEnc * 256 + [scan $char "%c"]}]
    }
    return [modexp $toEnc $publicKey]
}

proc rsa_decrypt {encrypted privateKey} {
    if {[lindex $privateKey 0] ne "privateKey"} {error "key handling"}
    set toDec [modexp $encrypted $privateKey]
    for {set message ""} {$toDec > 0} {set toDec [expr {$toDec >> 8}]} {
	append message [format "%c" [expr {$toDec & 255}]]
    }
    return [encoding convertfrom utf-8 [string reverse $message]]
}

# Assemble packaged public and private keys
set e 65537
set n 9516311845790656153499716760847001433441357
set d 5617843187844953170308463622230283376298685
set publicKey  [list "publicKey"  $e $n]
set privateKey [list "privateKey" $d $n]

# Test on some input strings
foreach input {"Rosetta Code" "UTF-8 \u263a test"} {
    set enc [rsa_encrypt $input $publicKey]
    set dec [rsa_decrypt $enc $privateKey]
    puts "$input -> $enc -> $dec"
}
