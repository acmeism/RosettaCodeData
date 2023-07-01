proc AP {k x1 x2 x3 x4 x5} {expr {$k<=0 ? [eval $x4]+[eval $x5] : [BP \#[info level] $x1 $x2 $x3 $x4]}}
proc BP {level x1 x2 x3 x4} {AP [uplevel $level {incr k -1}] [info level 0] $x1 $x2 $x3 $x4}
proc C {val} {return $val}
interp recursionlimit {} 1157
AP 10 {C 1} {C -1} {C -1} {C 1} {C 0}
