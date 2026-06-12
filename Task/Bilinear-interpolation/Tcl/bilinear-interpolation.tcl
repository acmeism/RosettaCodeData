package require Tk

proc pixel {f} {
    if {$f < 0} {
        error "why is $f?"
    }
    set i [expr {0xff & entier(0xff*$f)}]
    format #%02x%02x%02x $i [expr {255-$i}] 127
}

proc bilerp {im O X Y XY} {
    set w [image width $im]
    set h [image height $im]
    set dx [expr {1.0/$w}]
    set dy [expr {1.0/$h}]
    set a0 $O
    set a1 [expr {$X - $O}]
    set a2 [expr {$Y - $O}]
    set a3 [expr {$O + $XY - ($X + $Y)}]
    for {set y 0} {$y < $h} {incr y} {
        for {set x 0} {$x < $w} {incr x} {
            set i [expr {$x * $dx}]
            set j [expr {$y * $dy}]
            set xv [expr {$a0 + $a1*$i + $a2*$j + $a3*$i*$j}]
            set y [expr {$h - $y}] ;# invert for screen coords
            $im put [pixel $xv] -to $x $y
        }
    }
}

proc save {im} {
    set fn [tk_getSaveFile -defaultextension png]
    if {$fn eq ""} return
    set fd [open $fn wb]
    puts -nonewline $fd [$im data -format png]
    close $fd
    tk_messageBox -message "Saved as $fn!"
}

set im [image create photo -width 200 -height 200]
puts [time {bilerp $im 0 1 1 0.5} 1]
pack [label .l1 -image $im]
pack [button .b -text "save" -command [list save $im]]

