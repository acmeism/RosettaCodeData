proc multilist {value args} {
    set res $value
    foreach dim [lreverse $args] {
        set res [lrepeat $dim $res]
    }
    return $res
}
