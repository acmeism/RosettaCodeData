proc is_disarium {num} {
    set n num
    set sum 0
    set i 1
    set ch 1
    foreach char [split $num {}] {
        scan $char %d ch
        set sum [ expr ($sum + $ch ** $i)]
        incr i
    }
    return [ expr $num == $sum ? 1 : 0]
}
set i 0
set count 0
while { $count < 19 } {
    if [ is_disarium $i ] {
        puts -nonewline  "${i} "
        incr count
    }
    incr i
}
puts ""
