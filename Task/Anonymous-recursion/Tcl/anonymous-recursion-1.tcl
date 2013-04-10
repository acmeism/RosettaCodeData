proc fib n {
    # sanity checks
    if {[incr n 0] < 0} {error "argument may not be negative"}
    apply {x {
	if {$x < 2} {return $x}
	# Extract the lambda term from the stack introspector for brevity
	set f [lindex [info level 0] 1]
	expr {[apply $f [incr x -1]] + [apply $f [incr x -1]]}
    }} $n
}
