package require Tk

# create widgets
canvas .canvas
frame .controls

ttk::label .legend -text " r = a + b θ "
ttk::label .label_a -text "a ="
ttk::entry .entry_a -textvariable a
ttk::label .label_b -text "a ="
ttk::entry .entry_b -textvariable b
button .button -text "Redraw" -command draw

# layout
grid .canvas .controls -sticky nsew
grid .legend - -sticky ns -in .controls
grid .label_a .entry_a -sticky nsew -in .controls
grid .label_b .entry_b -sticky nsew -in .controls
grid .button - -sticky ns -in .controls

# make the canvas resize with the window
grid columnconfigure . 0 -weight 1
grid rowconfigure . 0 -weight 1

# spiral parameters:
set a .2
set b .05

proc draw {} {
    variable a
    variable b

    # make sure inputs are valid:
    if {![string is double $a] || ![string is double $b]} return
    if {$a == 0 || $b == 0} return

    set w [winfo width .canvas]
    set h [winfo height .canvas]
    set r 0
    set pi [expr {4*atan(1)}]
    set step [expr {$pi / $w}]
    for {set t 0} {$r < 2} {set t [expr {$t + $step}]} {
        set r [expr {$a + $b * $t}]
        set y [expr {sin($t) * $r}]
        set x [expr {cos($t) * $r}]

        # transform to canvas co-ordinates
        set y [expr {entier((1+$y)*$h/2)}]
        set x [expr {entier((1+$x)*$w/2)}]
        lappend coords $x $y
    }
    .canvas delete all
    set id [.canvas create line $coords -fill red]
}

# draw whenever parameters are changed
# ";#" so extra trace arguments are ignored
trace add variable a write {draw;#}
trace add variable b write {draw;#}

wm protocol . WM_DELETE_WINDOW exit ;# exit when window is closed

update  ;# lay out widgets before trying to draw
draw
vwait forever ;# go into event loop until window is closed
