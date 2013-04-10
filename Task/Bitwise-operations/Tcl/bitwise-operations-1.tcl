proc bitwise {a b} {
    puts [format "a and b: %#08x" [expr {$a & $b}]]
    puts [format "a or b: %#08x"  [expr {$a | $b}]]
    puts [format "a xor b: %#08x" [expr {$a ^ $b}]]
    puts [format "not a: %#08x"   [expr {~$a}]]
    puts [format "a << b: %#08x"  [expr {$a << $b}]]
    puts [format "a >> b: %#08x"  [expr {$a >> $b}]]
}
