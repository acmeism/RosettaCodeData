proc fs {f s} {
    set r {}
    foreach n $s {
	lappend r [{*}$f $n]
    }
    return $r
}
proc f1 x {expr {$x * 2}}
proc f2 x {expr {$x ** 2}}
set fsf1 [partial fs f1]
set fsf2 [partial fs f2]
foreach s {{0 1 2 3} {2 4 6 8}} {
    puts "$s ==f1==> [$fsf1 $s]"
    puts "$s ==f2==> [$fsf2 $s]"
}
