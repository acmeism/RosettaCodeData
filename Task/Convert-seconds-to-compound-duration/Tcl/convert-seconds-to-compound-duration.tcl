proc sec2str {i} {
    set factors {
        sec 60
        min 60
        hr  24
        d   7
        wk  Inf
    }
    set result ""
    foreach {label max} $factors {
        if {$i >= $max} {
            set r [expr {$i % $max}]
            set i [expr {$i / $max}]
            if {$r} {
                lappend result "$r $label"
            }
        } else {
            if {$i > 0} {
                lappend result "$i $label"
            }
            break
        }
    }
    join [lreverse $result] ", "
}

proc check {cmd res} {
    set r [uplevel 1 $cmd]
    if {$r eq $res} {
        puts "Ok! $cmd \t = $res"
    } else {
        puts "ERROR: $cmd = $r \t expected $res"
    }
}

check {sec2str 7259}    {2 hr, 59 sec}
check {sec2str 86400}   {1 d}
check {sec2str 6000000} {9 wk, 6 d, 10 hr, 40 min}
