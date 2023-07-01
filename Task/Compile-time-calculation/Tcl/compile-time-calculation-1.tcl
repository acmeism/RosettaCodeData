proc makeFacExpr n {
    set exp 1
    for {set i 2} {$i <= $n} {incr i} {
        append exp " * $i"
    }
    return "expr \{$exp\}"
}
eval [makeFacExpr 10]
