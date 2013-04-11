# Simple driver for the circuit
proc 4add_driver {a b} {
    lassign [split $a {}] a3 a2 a1 a0
    lassign [split $b {}] b3 b2 b1 b0
    lassign [split 00000 {}] s3 s2 s1 s0 v

    4add a0 a1 a2 a3  b0 b1 b2 b3  s0 s1 s2 s3  v

    return "$s3$s2$s1$s0 overflow=$v"
}
set a 1011
set b 0110
puts $a+$b=[4add_driver $a $b]
