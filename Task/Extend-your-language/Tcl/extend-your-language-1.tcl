proc if2 {cond1 cond2 bothTrueBody firstTrueBody secondTrueBody bothFalseBody} {
    # Must evaluate both conditions, and should do so in order
    set c1 [uplevel 1 [list expr $cond1]
    set c2 [uplevel 1 [list expr $cond2]
    # Now use that to decide what to do
    if {$c1 && $c2} {
        uplevel 1 $bothTrueBody
    } elseif {$c1 && !$c2} {
        uplevel 1 $firstTrueBody
    } elseif {$c2 && !$c1} {
        uplevel 1 $secondTrueBody
    } else {
        uplevel 1 $bothFalseBody
    }
}
