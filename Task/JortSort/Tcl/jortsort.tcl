proc jortsort {args} {
    set list [lindex $args end]
    set list [list {*}$list]    ;# ensure canonical list form
    set options [lrange $args 0 end-1]
    expr {[lsort {*}$options $list] eq $list}
}
