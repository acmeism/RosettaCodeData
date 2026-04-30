#!/usr/bin/env  tclsh

proc point {x {y ""}} {

    if { [llength $x] eq 2 } {
	    set y [lindex $x 1]
	    set x [lindex $x 0]
    }

    try {
	    set p [list [expr {double($x)}] [expr {double($y)}] ]
    } on error {err} {
	    puts stderr "invalid point $x $y"
	    puts stderr "error: \t $::errorInfo"
	    exit 1
    }
    return  $p
}

proc triangle {a b c} {

    try {
	    set A [point [lindex $a 0]  [lindex $a 1]]
	    set B [point [lindex $b 0]  [lindex $b 1]]
	    set C [point [lindex $c 0]  [lindex $c 1]]
    } on error { err } {
	    puts stderr "invalid triangle $a $b $c"
	    puts stderr "error: \t $::errorInfo"
	    exit 1
    }

    return  [list $A $B $C]
}


proc in_bounding_box {t p} {

    lassign $t  A B C

    lassign $A x1 y1
    lassign $B x2 y2
    lassign $C x3 y3
    lassign $p x y

    set xmin  [expr { min( $x1, $x2, $x3) } ]
    set xmax  [expr { max( $x1, $x2, $x3) } ]

    set ymin  [expr { min( $y1, $y2 ,$y3) } ]
    set ymax  [expr { max( $y1, $y2 ,$y3) } ]

    set P1 [expr { $x < $xmin}]
    set P2 [expr { $x > $xmax}]
    set P3 [expr { $y < $ymin}]
    set P4 [expr { $y > $xmax}]

    set in_box [expr { !($P1 || $P2 || $P3 || $P4) }]

    return $in_box
}


proc in_triangle { t p } {

    lassign $t  A B C

    lassign $A x1 y1
    lassign $B x2 y2
    lassign $C x3 y3
    lassign $p x y

    # inner proc
    proc side { p1 p2 p } {

	    lassign $p1 x1 y1
	    lassign $p2 x2 y2
	    lassign $p x y
	
	    set res [expr { (($y2 - $y1) * ($x - $x1))
		      + (($x1 - $x2) * ($y - $y1)) }]
	    return $res
    }

    set side1 [side $A $B $p]
    set side2 [side $B $C $p]
    set side3 [side $C $A $p]

    set X [expr {$side1 >= 0}]
    set Y [expr {$side2 >= 0}]
    set Z [expr {$side3 >= 0}]

    return [expr {$X && $Y && $Z}]
}

# processing starts here

set tp1  [point 1.5 2.4  ]
set tp2  [point 5.1 -3.1 ]
set tp3  [point -3.8 1.2 ]
set t    [triangle $tp1 $tp2 $tp3]

set p1 [point 0.0 0.0]
set p2 [point 0.0 1.0]
set p3 [point 3.0 1.0]

foreach p [list $p1 $p2 $p3] {
    set bb [in_bounding_box $t $p]

    if {$bb} {
	    set it [in_triangle $t $p]

	    if {$it} {
	        puts stdout "point ($p) is inside of triangle ($t)"
	    } else {
	        puts stdout "point ($p) is not inside of triangle ($t)"
	   }
    }
}
