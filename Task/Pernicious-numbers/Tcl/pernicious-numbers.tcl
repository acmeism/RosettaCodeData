package require math::numtheory

proc pernicious {n} {
    ::math::numtheory::isprime [tcl::mathop::+ {*}[split [format %b $n] ""]]
}

for {set n 0;set p {}} {[llength $p] < 25} {incr n} {
    if {[pernicious $n]} {lappend p $n}
}
puts [join $p ","]
for {set n 888888877; set p {}} {$n <= 888888888} {incr n} {
    if {[pernicious $n]} {lappend p $n}
}
puts [join $p ","]
