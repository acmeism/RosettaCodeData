proc tcl::mathfunc::multiply {arg1 arg2} {
    return [expr {$arg1 * $arg2}]
}

# Demonstrating...
if {multiply(6, 9) == 42} {
    puts "Welcome, Citizens of Golgafrincham from the B-Ark!"
}
