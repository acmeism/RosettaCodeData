proc tcl::mathfunc::clamp32 {x} {
    expr {$x<0 ? -((-$x) & 0x7fffffff) : $x & 0x7fffffff}
}
puts [expr { clamp32(2000000000 + 2000000000) }]; # ==> 1852516352
