proc bitwiseUnsupported {a b} {
    set bits 0xFFFFFFFF
    # Force interpretation as a 32-bit unsigned value
    puts [format "a ArithRightShift b: %#08x" [expr {($a & $bits) >> $b}]]
    puts [format "a RotateRight b: %#08x" [expr {
        (($a >> $b) & ($bits >> $b)) |
        (($a << (32-$b)) & ($bits ^ ($bits >> $b)))
    }]]
    puts [format "a RotateLeft b: %#08x" [expr {
        (($a << $b) & $bits & ($bits << $b)) |
        (($a >> (32-$b)) & ($bits ^ ($bits << $b)))
    }]]
}
