err-print: func [
    "Print value to stderr."
    value
] either/only exists? %/dev/stderr [
    ;; On Posix
    write %/dev/stderr value
][  ;; On Windows
    modify system/ports/output 'error true
    also print value
    modify system/ports/output 'error false
]

err-print "Goodbye, World!"
