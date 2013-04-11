proc numtohex {num} {
    binary scan [string trimleft [binary format W $num] \0] H* hexEncoded
    regsub -all "..(?=.)" $hexEncoded "&:"
}
proc strtohex {string} {
    binary scan $string H* hexEncoded
    regsub -all "..(?=.)" $hexEncoded "&:"
}
foreach testcase {
    123
    254 255 256 257
    65534 65535 65536 65537
    2097152 2097151
    12345678901234566789
} {
    set encoded [vlqEncode $testcase]
    binary scan $encoded H* hexEncoded
    regsub -all {..(?=.)} $hexEncoded &: hexEncoded
    set decoded [vlqDecode $encoded]
    puts "$testcase ([numtohex $testcase]) ==>\
	[strtohex $encoded] ([string length $encoded] bytes) ==>\
	$decoded"
}
