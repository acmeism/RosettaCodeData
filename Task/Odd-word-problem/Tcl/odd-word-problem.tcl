package require Tcl 8.6

proc fwd c {
    expr {[string is alpha $c] ? "[fwd [yield f][puts -nonewline $c]]" : $c}
}
proc rev c {
    expr {[string is alpha $c] ? "[rev [yield r]][puts -nonewline $c]" : $c}
}
coroutine f while 1 {puts -nonewline [fwd [yield r]]}
coroutine r while 1 {puts -nonewline [rev [yield f]]}
for {set coro f} {![eof stdin]} {} {
    set coro [$coro [read stdin 1]]
}
