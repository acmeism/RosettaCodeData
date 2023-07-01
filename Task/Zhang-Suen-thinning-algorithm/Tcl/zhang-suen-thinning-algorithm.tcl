# -*- coding: utf-8 -*-

set data {
00000000000000000000000000000000
01111111110000000111111110000000
01110001111000001111001111000000
01110000111000001110000111000000
01110001111000001110000000000000
01111111110000001110000000000000
01110111100000001110000111000000
01110011110011101111001111011100
01110001111011100111111110011100
00000000000000000000000000000000
}
proc zhang-suen data {
    set data [string trim $data]
    while 1 {
	set n 0
	incr n [step 1 data]
	incr n [step 2 data]
	if !$n break
    }
    return $data
}
proc step {number _data} {
    upvar 1 $_data data
    set xmax [string length [lindex $data 0]]
    set ymax [llength $data]
    switch -- $number {
	1 {set cond {(!$P2 || !$P4 || !$P6) && (!$P4 || !$P6 || !$P8)}}
	2 {set cond {(!$P2 || !$P4 || !$P8) && (!$P2 || !$P6 || !$P8)}}
    }
    set hits {}
    for {set x 1} {$x < $xmax-1} {incr x} {
	for {set y 1} {$y < $ymax-1} {incr y} {
	    if {[getpix $data $x $y] == 1} {
		set b [B $data $x $y]
		if {2 <= $b && $b <= 6} {
		    if {[A $data $x $y] == 1} {
			set P2 [getpix $data $x [expr $y-1]]
			set P4 [getpix $data [expr $x+1] $y]
			set P6 [getpix $data $x [expr $y+1]]
			set P8 [getpix $data [expr $x-1] $y]
			if $cond {lappend hits $x $y}
		    }
		}
	    }
	}
    }
    foreach {x y} $hits {set data [setpix $data $x $y 0]}
    return [llength $hits]
}
proc A {data x y} {
    set res 0
    set last [getpix $data $x [expr $y-1]]
    foreach {dx dy} {1 -1  1 0  1 1  0 1  -1 1  -1 0  -1 -1  0 -1} {
	set this [getpix $data [expr $x+$dx] [expr $y+$dy]]
	if {$this > $last} {incr res}
	set last $this
    }
    return $res
}
proc B {data x y} {
    set res 0
    foreach {dx dy} {1 -1  1 0  1 1  0 1  -1 1  -1 0  -1 -1  0 -1} {
	incr res [getpix $data [expr $x+$dx] [expr $y+$dy]]
    }
    return $res
}
proc getpix {data x y} {
    string index [lindex $data $y] $x
}
proc setpix {data x y val} {
    set row [lindex $data $y]
    lset data $y [string replace $row $x $x $val]
    return $data
}
puts [string map {1 @ 0 .} [join [zhang-suen $data] \n]]
