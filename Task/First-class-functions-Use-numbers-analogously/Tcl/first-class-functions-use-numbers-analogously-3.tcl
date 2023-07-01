set x  2.0
set xi 0.5
set y  4.0
set yi 0.25
set z  [expr {$x + $y}]
set zi [expr {1.0 / ( $x + $y )}]
set numlist [list $x $y $z]
set numlisti [list $xi $yi $zi]
foreach a $numlist b $numlisti {
    puts [format "%g * %g * 0.5 = %g" $a $b [{*}[multiplier $a $b] 0.5]]
}
