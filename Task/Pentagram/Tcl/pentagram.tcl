package require Tk 8.6   	;# lmap is new in Tcl/Tk 8.6

set pi [expr 4*atan(1)]

pack [canvas .c] -expand yes -fill both     ;# create the canvas

update          ;# draw everything so the dimensions are accurate

set w [winfo width .c]          ;# calculate appropriate dimensions
set h [winfo height .c]
set r [expr {min($w,$h) * 0.45}]

set points [lmap n {0 1 2 3 4 5} {
    set n [expr {$n * 2}]
    set y [expr {sin($pi * 2 * $n / 5) * $r + $h / 2}]
    set x [expr {cos($pi * 2 * $n / 5) * $r + $w / 2}]
    list $x $y
}]
set points [concat {*}$points]  ;# flatten the list

puts [.c create line $points]

;# a fun reader exercise is to make the shape respond to mouse events,
;# or animate it!
