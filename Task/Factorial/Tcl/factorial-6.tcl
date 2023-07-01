package require math::special

proc gfact n {
    expr {round([::math::special::Gamma [expr {$n+1}]])}
}
