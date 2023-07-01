package require Tcl 8.5 ;# for coroutines

proc 2pals {} {
    yield 0
    yield 1
    while 1 {
        incr i
        set a [format %b $i]
        set b [string reverse $a]
        yield ${a}$b
        yield ${a}0$b
        yield ${a}1$b
    }
}
