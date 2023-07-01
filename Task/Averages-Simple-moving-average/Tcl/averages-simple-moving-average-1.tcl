oo::class create SimpleMovingAverage {
    variable vals idx
    constructor {{period 3}} {
        set idx end-[expr {$period-1}]
        set vals {}
    }
    method val x {
        set vals [lrange [list {*}$vals $x] $idx end]
        expr {[tcl::mathop::+ {*}$vals]/double([llength $vals])}
    }
}
