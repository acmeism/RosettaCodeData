proc push {stackvar value} {
    upvar 1 $stackvar stack
    lappend stack $value
}
proc pop {stackvar} {
    upvar 1 $stackvar stack
    set value [lindex $stack 0]
    set stack [lrange $stack 1 end]
    return $value
}
proc size {stackvar} {
    upvar 1 $stackvar stack
    llength $stack
}
proc empty {stackvar} {
    upvar 1 $stackvar stack
    expr {[size stack] == 0}
}
proc peek {stackvar} {
    upvar 1 $stackvar stack
    lindex $stack 0
}

set Q [list]
empty Q ;# ==> 1 (true)
push Q foo
empty Q ;# ==> 0 (false)
push Q bar
peek Q ;# ==> foo
pop Q ;# ==> foo
peek Q ;# ==> bar
