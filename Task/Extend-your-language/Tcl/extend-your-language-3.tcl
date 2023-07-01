proc if2 {cond1 cond2 body00 body01 body10 body11} {
    # Must evaluate both conditions, and should do so in order
    # Extra negations ensure boolean interpretation
    set c1 [expr {![uplevel 1 [list expr $cond1]]}]
    set c2 [expr {![uplevel 1 [list expr $cond2]]}]
    # Use those values to pick the script to evaluate
    uplevel 1 [set body$c1$c2]
}
