proc utf8 {codepoint} {
    scan $codepoint %llx cp
    if {$cp < 0x10000} {
        set str [subst \\u$codepoint]               ;# substitute per Tcl backslash rule
        set bytes [encoding convertto utf-8 $str]   ;# encode
    } else {                                        ;# codepoints beyond the BMP need manual approach
        set bits [format %021b $cp]                 ;# format as binary string
        set unibits    11110[string range $bits 0 2];# insert extra bits for utf-8 4-byte encoding
        append unibits 10[string range $bits 3 8]
        append unibits 10[string range $bits 9 14]
        append unibits 10[string range $bits 15 20]
        set bytes [binary format B* $unibits]       ;# turn into a sequence of bytes
    }
    return $bytes
}

proc hexchars {s} {
    binary scan $s H* hex
    regsub -all .. $hex {\0 }
}

# for the test, we assume the tty is in utf-8 mode and can handle beyond-BMP chars
# so set output mode to binary so we can write raw bytes!
chan configure stdout -encoding binary
foreach codepoint { 41 F6 416 20AC 1D11E } {
    set utf8 [utf8 $codepoint]
    puts "[format U+%04s $codepoint]\t$utf8\t[hexchars $utf8]"
}
