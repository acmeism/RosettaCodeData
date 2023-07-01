oo::class create SubCipher {
    variable Alphabet
    variable Key
    variable EncMap
    variable DecMap
    constructor {{alphabet abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ} {cipherbet ""}} {
        set Alphabet $alphabet
        if {$cipherbet eq ""} {
            my key [my RandomKey]
        } else {
            my key $cipherbet
        }
    }
    method key args {
        if {$args eq ""} {
            return $Key
        } elseif {[llength $args] > 1} {
            throw {TCL WRONGARGS} "Expected \"[self class] key\" or \"[self class]\" key keystring"
        }
        lassign $args s

        set size [string length $Alphabet]
        if {[string length $s] != $size} {
            return -code error "Key must be $size chars long!"
        }
        set encmap {}
        set decmap {}
        foreach c [split $Alphabet {}] e [split $s {}] {
            dict set encmap $c $e
            dict set decmap $e $c
        }
        if {[dict size $encmap] != $size} {
            return -code error "Alphabet has repeating characters!"
        }
        if {[dict size $decmap] != $size} {
            return -code error "Key has repeating characters!"
        }
        set Key $s
        set EncMap $encmap
        set DecMap $decmap
    }
    method RandomKey {} {
        set chars $Alphabet
        set key {}
        for {set n [string length $chars]} {$n > 0} {incr n -1} {
            set i [expr {int(rand()*$n)}]
            append key [string index $chars $i]
            set chars [string range $chars 0 $i-1][string range $chars $i+1 end]
        }
        return $key
    }

    method enc {s} {
        string map $EncMap $s
    }
    method dec {s} {
        string map $DecMap $s
    }
}
