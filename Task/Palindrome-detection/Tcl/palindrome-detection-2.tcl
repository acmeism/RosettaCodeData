proc palindrome_r {s} {
    if {[string length $s] <= 1} {
        return true
    } elseif {[string index $s 0] ne [string index $s end]} {
        return false
    } else {
        return [palindrome_r [string range $s 1 end-1]]
    }
}
