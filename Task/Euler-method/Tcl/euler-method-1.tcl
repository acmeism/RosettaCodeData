proc euler {f y0 a b h} {
    puts "computing $f over \[$a..$b\], step $h"
    set y [expr {double($y0)}]
    for {set t [expr {double($a)}]} {$t < $b} {set t [expr {$t + $h}]} {
	puts [format "%.3f\t%.3f" $t $y]
	set y [expr {$y + $h * double([$f $t $y])}]
    }
    puts "done"
}
