method operation {} {
    if { [info exists delegate] &&
         [info object isa object $delegate] &&
         "thing" in [info object methods $delegate -all]
    } then {
        set result [$delegate thing]
    } else {
        set result "default implementation"
    }
}
