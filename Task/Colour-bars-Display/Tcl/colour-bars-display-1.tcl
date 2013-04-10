package require Tcl 8.5
package require Tk 8.5

wm attributes . -fullscreen 1
pack [canvas .c -highlightthick 0] -fill both -expand 1
set colors {black red green blue magenta cyan yellow white}

for {set x 0} {$x < [winfo screenwidth .c]} {incr x 8} {
    .c create rectangle $x 0 [expr {$x+7}] [winfo screenheight .c] \
            -fill [lindex $colors 0] -outline {}
    set colors [list {*}[lrange $colors 1 end] [lindex $colors 0]]
}
