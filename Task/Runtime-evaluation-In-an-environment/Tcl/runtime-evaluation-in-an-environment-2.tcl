proc eval_with_x {code val1 val2} {
    expr {[set x $val2; eval $code] - [set x $val1; eval $code]}
}
eval_with_x {expr {2**$x}} 3 5 ;# ==> 24
