proc example {x y args} {
    set keyargs {arg1 default1 arg2 default2}
    if {[llength $args] % 2 != 0} {
		error "$args: invalid keyword arguments (spec: $keyargs)"
	}
	set margs [dict merge $keyargs $args]
	if {[dict size $margs] != [dict size $keyargs]} {
		error "$args: invalid keyword arguments (spec: $keyargs)"
	}
	lassign [dict values $margs] {*}[dict keys $margs]
	puts "x: $x, y: $y, arg1: $arg1, arg2: $arg2"
}
example 1 2         # => x: 1, y: 2, arg1: default1, arg2: default2
example 1 2 arg2 3  # => x: 1, y: 2, arg1: default1, arg2: 3
example 1 2 test 3  # => test 3: invalid keyword arguments (spec: arg1 default1 arg2 default2)
example 1 2 test    # => test: invalid keyword arguments (spec: arg1 default1 arg2 default2)
