package require Tcl 8.5

# Create our little language
proc pins args {
    # Just declaration...
    foreach p $args {upvar 1 $p v}
}
proc gate {name pins body} {
    foreach p $pins {
	lappend args _$p
	append v " \$_$p $p"
    }
    proc $name $args "upvar 1 $v;$body"
}

# Fundamental gates; these are the only ones that use Tcl math ops
gate not {x out}   {
    set out [expr {1 & ~$x}]
}
gate and {x y out} {
    set out [expr {$x & $y}]
}
gate or  {x y out} {
    set out [expr {$x | $y}]
}
gate GND pin {
    set pin 0
}

# Composite gates: XOR
gate xor {x y out} {
    pins nx ny x_ny nx_y

    not x          nx
    not y          ny
    and x ny       x_ny
    and nx y       nx_y
    or  x_ny nx_y  out
}

# Composite gates: half adder
gate halfadd {a b sum carry} {
    xor a b  sum
    and a b  carry
}

# Composite gates: full adder
gate fulladd {a b c0 sum c1} {
    pins sum_ac carry_ac carry_sb

    halfadd c0 a          sum_ac carry_ac
    halfadd sum_ac b      sum carry_sb
    or carry_ac carry_sb  c1
}

# Composite gates: 4-bit adder
gate 4add {a0 a1 a2 a3  b0 b1 b2 b3  s0 s1 s2 s3  v} {
    pins c0 c1 c2 c3

    GND c0
    fulladd a0 b0 c0  s0 c1
    fulladd a1 b1 c1  s1 c2
    fulladd a2 b2 c2  s2 c3
    fulladd a3 b3 c3  s3 v
}
