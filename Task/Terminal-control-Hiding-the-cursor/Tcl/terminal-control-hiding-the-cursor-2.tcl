foreach x {visible invisible normal} {
    cursorVisibility $x
    puts -nonewline "$x cursor -> "
    flush stdout
    after 3000
    puts {}
}
