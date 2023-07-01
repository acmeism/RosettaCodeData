namespace path ::tcl::mathop
proc vec {op a b} {
    if {[llength $a] == 1 && [llength $b] == 1} {
        $op $a $b
    } elseif {[llength $a]==1} {
        lmap i $b {vec $op $a $i}
    } elseif {[llength $b]==1} {
        lmap i $a {vec $op $i $b}
    } elseif {[llength $a] == [llength $b]} {
        lmap i $a j $b {vec $op $i $j}
    } else {error "length mismatch [llength $a] != [llength $b]"}
}

proc polar {r t} {
    list [expr {$r * cos($t)}] [expr {$r * sin($t)}]
}

proc check {cmd res} {
    set r [uplevel 1 $cmd]
    if {$r eq $res} {
        puts "Ok! $cmd \t = $res"
    } else {
        puts "ERROR: $cmd = $r \t expected $res"
    }
}

check {vec + {5 7} {2 3}}   {7 10}
check {vec - {5 7} {2 3}}   {3 4}
check {vec * {5 7} 11}      {55 77}
check {vec / {5 7} 2.0}     {2.5 3.5}
check {polar 2 0.785398}    {1.41421 1.41421}
