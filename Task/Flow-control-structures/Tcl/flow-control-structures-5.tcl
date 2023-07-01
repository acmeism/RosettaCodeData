try {
    # Just a silly example...
    set f [open $filename]
    expr 1/0
    string length [read $f]
} trap {ARITH DIVZERO} {} {
    puts "divided by zero"
} finally {
    close $f
}
