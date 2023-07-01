package require Tcl 8.5
proc eval_with {body a b} {
    set lambda [list x $body]
    expr {[apply $lambda $b] - [apply $lambda $a]}
}

eval_with {expr {2**$x}} 3 5  ;# ==> 24
