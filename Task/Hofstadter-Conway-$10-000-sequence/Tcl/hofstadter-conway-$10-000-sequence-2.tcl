for {set p 1} {$p<20} {incr p} {
    set end [expr {2**($p+1)}]
    set maxI 0; set maxV 0
    for {set i [expr {2**$p}]} {$i<=$end} {incr i} {
	set v [expr {[hofcon10k $i] / double($i)}]
	if {$v > $maxV} {set maxV $v; set maxI $i}
    }
    puts "max in 2**$p..2**[expr {$p+1}] at $maxI : $maxV"
}
