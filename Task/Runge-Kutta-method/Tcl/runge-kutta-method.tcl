package require Tcl 8.5

# Hack to bring argument function into expression
proc tcl::mathfunc::dy {t y} {upvar 1 dyFn dyFn; $dyFn $t $y}

proc rk4step {dyFn y* t* dt} {
    upvar 1 ${y*} y ${t*} t
    set dy1 [expr {$dt * dy($t,       $y)}]
    set dy2 [expr {$dt * dy($t+$dt/2, $y+$dy1/2)}]
    set dy3 [expr {$dt * dy($t+$dt/2, $y+$dy2/2)}]
    set dy4 [expr {$dt * dy($t+$dt,   $y+$dy3)}]
    set y [expr {$y + ($dy1 + 2*$dy2 + 2*$dy3 + $dy4)/6.0}]
    set t [expr {$t + $dt}]
}

proc y {t} {expr {($t**2 + 4)**2 / 16}}
proc δy {t y} {expr {$t * sqrt($y)}}

proc printvals {t y} {
    set err [expr {abs($y - [y $t])}]
    puts [format "y(%.1f) = %.8f\tError: %.8e" $t $y $err]
}

set t 0.0
set y 1.0
set dt 0.1
printvals $t $y
for {set i 1} {$i <= 101} {incr i} {
    rk4step  δy  y t  $dt
    if {$i%10 == 0} {
	printvals $t $y
    }
}
