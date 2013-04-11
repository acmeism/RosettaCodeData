oo::class create CanClone {
    method clone {{name {}}} {
        # Make a bare, optionally named, copy of the object
        set new [oo::copy [self] {*}[expr {$name eq "" ? {} : [list $name]}]]

        # Reproduce the basic variable state of the object
        set newns [info object namespace $new]
        foreach v [info object vars [self]] {
            namespace upvar [namespace current] $v v1
            namespace upvar $newns $v v2
            if {[array exists v1]} {
                array set v2 [array get v1]
            } else {
                set v2 $v1
            }
        }
        # Other object state is possible like open file handles. Cloning that is
        # properly left to subclasses, of course.

        return $new
    }
}

# Now a demonstration
oo::class create Example {
    superclass CanClone
    variable Count Name
    constructor {name} {set Name $name;set Count 0}
    method step {} {incr Count;return}
    method print {} {puts "this is $Name in [self], stepped $Count times"}
    method rename {newName} {set Name $newName}
}
set obj1 [Example new "Abracadabra"]
$obj1 step
$obj1 step
$obj1 print
set obj2 [$obj1 clone]
$obj2 step
$obj2 print
$obj2 rename "Hocus Pocus"
$obj2 print
$obj1 print
