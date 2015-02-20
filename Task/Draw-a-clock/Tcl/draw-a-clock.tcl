package require Tcl 8.5
package require Tk

# GUI code
pack [canvas .c -width 200 -height 200]
.c create oval 20 20 180 180 -width 10 -fill {} -outline grey70
.c create line 0 0 1 1 -tags hour   -width 6 -cap round -fill black
.c create line 0 0 1 1 -tags minute -width 4 -cap round -fill black
.c create line 0 0 1 1 -tags second -width 2 -cap round -fill grey30
proc updateClock t {
    scan [clock format $t -format "%H %M %S"] "%d%d%d" h m s
    # On an analog clock, the hour and minute hands move gradually
    set m [expr {$m + $s/60.0}]
    set h [expr {($h % 12 + $m/60.0) * 5}]
    foreach tag {hour minute second} value [list $h $m $s] len {50 80 80} {
	.c coords $tag 100 100 \
	    [expr {100 + $len*sin($value/30.0*3.14159)}] \
	    [expr {100 - $len*cos($value/30.0*3.14159)}]
    }
}

# Timer code, accurate to within a quarter second
set time 0
proc ticker {} {
    global time
    set t [clock seconds]
    after 250 ticker
    if {$t != $time} {
	set time $t
	updateClock $t
    }
}
ticker
