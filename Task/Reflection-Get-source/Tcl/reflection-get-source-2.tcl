proc ::getproc name {
    set name [uplevel 1 [list namespace which -command $name]]
    set args [info args $name]
    set args [lmap arg $args {  ;# handle default arguments, if it has them!
        if {[info default $name $arg default]} {
            list $name $default
        } else {
            return -level 0 $arg
        }
    }]
    set body [info body $name]
    list proc $name $args $body
}
