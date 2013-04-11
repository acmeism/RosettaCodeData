proc A {k x1 x2 x3 x4 x5} {
    expr {$k<=0 ? [eval $x4]+[eval $x5] : [B \#[info level]]}
}
proc B {level} {
    upvar $level k k x1 x1 x2 x2 x3 x3 x4 x4
    incr k -1
    A $k [info level 0] $x1 $x2 $x3 $x4
}
proc C {val} {return $val}
interp recursionlimit {} 1157
A 10 {C 1} {C -1} {C -1} {C 1} {C 0}
