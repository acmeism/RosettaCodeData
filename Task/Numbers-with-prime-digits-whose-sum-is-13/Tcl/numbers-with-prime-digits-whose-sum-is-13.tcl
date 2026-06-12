set res {}
set src [list {} 13]
while {[llength $src]} {
    set src [lassign $src n r]
    foreach d {2 3 5 7} {
        if {$d >= $r} {
            if {$d == $r} {lappend res "$n$d"}
            break
        }
        lappend src "$n$d" [expr {$r - $d}]
    }
}
puts $res
