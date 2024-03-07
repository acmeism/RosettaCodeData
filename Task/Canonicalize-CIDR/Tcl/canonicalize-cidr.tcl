# Canonicalize CIDR in Tcl

# Convert dotted IP address to integer
proc dotted_to_int {dotted} {
    set digits [split $dotted .]
    set result 0
    foreach digit $digits {
        set result [expr {$result * 256 + $digit}]
    }
    return $result
}

# Convert integer IP address to dotted format
proc int_to_dotted {ip} {
    set result {}
    for {set i 3} {$i >= 0} {incr i -1} {
        lappend result [expr {($ip >> ($i * 8)) & 0xFF}]
    }
    return [join $result .]
}

# Calculate network mask
proc network_mask {number_of_bits} {
    return [expr {(1 << $number_of_bits) - 1 << (32 - $number_of_bits)}]
}

# Canonicalize IP address
proc canonicalize {ip} {
    regexp {^(.*)/(.*)$} $ip -> dotted network_bits
    set i [dotted_to_int $dotted]
    set mask [network_mask $network_bits]
    return [int_to_dotted [expr {$i & $mask}]]/$network_bits
}

# Test cases
set test_cases {
    {"36.18.154.103/12" "36.16.0.0/12"}
    {"62.62.197.11/29" "62.62.197.8/29"}
    {"67.137.119.181/4" "64.0.0.0/4"}
    {"161.214.74.21/24" "161.214.74.0/24"}
    {"184.232.176.184/18" "184.232.128.0/18"}
}

# Main execution
foreach test $test_cases {
    foreach {ip expect} $test {}
    set rv [canonicalize $ip]
    puts "$ip -> $rv"
    if {$rv ne $expect} {
        error "Test failed: $rv != $expect"
    }
}
