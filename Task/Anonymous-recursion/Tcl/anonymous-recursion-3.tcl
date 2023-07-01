proc fib n {
    if {[incr n 0] < 0} {error "argument may not be negative"}
    apply {x {expr {
        $x < 2
          ? $x
          : [apply [lindex [info level 0] 1] [incr x -1]]
            + [apply [lindex [info level 0] 1] [incr x -1]]
    }}} $n
}
