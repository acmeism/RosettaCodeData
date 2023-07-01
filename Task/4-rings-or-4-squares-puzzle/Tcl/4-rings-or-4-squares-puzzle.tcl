set vars {a b c d e f g}
set exprs {
    {$a+$b}
    {$b+$c+$d}
    {$d+$e+$f}
    {$f+$g}
}

proc permute {xs} {
    if {[llength $xs] < 2} {
        return $xs
    }
    set i -1
    foreach x $xs {
        incr i
        set rest [lreplace $xs $i $i]
        foreach rest [permute $rest] {
            lappend res [list $x {*}$rest]
        }
    }
    return $res
}

proc range {a b} {
    set a [uplevel 1 [list expr $a]]
    set b [uplevel 1 [list expr $b]]
    set res {}
    while {$a <= $b} {
        lappend res $a
        incr a
    }
    return $res
}

proc compile_4rings {vars exprs} {
    set script "set _ \[[list expr [lindex $exprs 0]]\]\n"
    foreach expr [lrange $exprs 1 end] {
        append script "if {\$_ != $expr} {return false}\n"
    }
    append script "return true\n"
    list $vars $script
}

proc solve_4rings {vars exprs range} {
    set lambda [compile_4rings $vars $exprs]
    foreach values [permute $range] {
        if {[apply $lambda {*}$values]} {
            puts " $values"
        }
    }
}

proc compile_4rings_hard {vars exprs values} {
    append script "set _ \[[list expr [lindex $exprs 0]]\]\n"
    foreach expr [lrange $exprs 1 end] {
        append script "if {\$_ != $expr} {continue}\n"
    }
    append script "incr res\n"
    foreach var $vars {
        set script [list foreach $var $values $script]
    }
    set script "set res 0\n$script\nreturn \$res"
    list {} $script
}

proc solve_4rings_hard {vars exprs range} {
    apply [compile_4rings_hard $vars $exprs $range]
}

puts "# Combinations of 1..7:"
solve_4rings $vars $exprs [range 1 7]
puts "# Combinations of 3..9:"
solve_4rings $vars $exprs [range 3 9]
puts "# Number of solutions, free over 0..9:"
puts [solve_4rings_hard $vars $exprs [range 0 9]]
