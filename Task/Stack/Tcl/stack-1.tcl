proc push {stackvar value} {
    upvar 1 $stackvar stack
    lappend stack $value
}
proc pop {stackvar} {
    upvar 1 $stackvar stack
    set value [lindex $stack end]
    set stack [lrange $stack 0 end-1]
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
    lindex $stack end
}

set S [list]
empty S ;# ==> 1 (true)
push S foo
empty S ;# ==> 0 (false)
push S bar
peek S ;# ==> bar
pop S ;# ==> bar
peek S ;# ==> foo
