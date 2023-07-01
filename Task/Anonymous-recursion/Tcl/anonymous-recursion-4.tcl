# Pick the lambda term out of the introspected caller's stack frame
proc tcl::mathfunc::recurse args {apply [lindex [info level -1] 1] {*}$args}
proc fib n {
    if {[incr n 0] < 0} {error "argument may not be negative"}
    apply {x {expr {
        $x < 2 ? $x : recurse([incr x -1]) + recurse([incr x -1])
    }}} $n
}
