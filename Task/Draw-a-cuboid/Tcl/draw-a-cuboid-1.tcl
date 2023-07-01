package require Tcl 8.5
package require Tk
package require math::linearalgebra
package require math::constants

# Helper for constructing a rectangular face in 3D
proc face {px1 py1 pz1 px2 py2 pz2 px3 py3 pz3 px4 py4 pz4 color} {
    set centroidX [expr {($px1+$px2+$px3+$px4)/4.0}]
    set centroidY [expr {($py1+$py2+$py3+$py4)/4.0}]
    set centroidZ [expr {($pz1+$pz2+$pz3+$pz4)/4.0}]
    list [list \
	      [list [expr {double($px1)}] [expr {double($py1)}] [expr {double($pz1)}]] \
	      [list [expr {double($px2)}] [expr {double($py2)}] [expr {double($pz2)}]] \
	      [list [expr {double($px3)}] [expr {double($py3)}] [expr {double($pz3)}]] \
	      [list [expr {double($px4)}] [expr {double($py4)}] [expr {double($pz4)}]]] \
	[list $centroidX $centroidY $centroidZ] \
	$color
}

# How to make a cuboid of given size at the origin
proc makeCuboid {size} {
    lassign $size x y z
    list \
	[face  0  0  0   0 $y  0  $x $y  0  $x  0  0  "#800000"] \
	[face  0  0  0   0 $y  0   0 $y $z   0  0 $z  "#ff8080"] \
	[face  0  0  0  $x  0  0  $x  0 $z   0  0 $z  "#000080"] \
	[face $x  0  0  $x $y  0  $x $y $z  $x  0 $z  "#008000"] \
	[face  0 $y  0  $x $y  0  $x $y $z   0 $y $z  "#80ff80"] \
	[face  0  0 $z  $x  0 $z  $x $y $z   0 $y $z  "#8080ff"]
}

# Project a shape onto a surface (Tk canvas); assumes that the shape's faces
# are simple and non-intersecting (i.e., it sorts by centroid z-order).
proc drawShape {surface shape} {
    global projection
    lassign $projection pmat poff
    lassign $poff px py pz
    foreach side $shape {
	lassign $side points centroid color
	set pc [::math::linearalgebra::matmul $pmat $centroid]
	lappend sorting [list [expr {[lindex $pc 2]+$pz}] $points $color]
    }
    foreach side [lsort -real -decreasing -index 0 $sorting] {
	lassign $side sortCriterion points color
	set plotpoints {}
	foreach p $points {
	    set p [::math::linearalgebra::matmul $pmat $p]
	    lappend plotpoints \
		[expr {[lindex $p 0]+$px}] [expr {[lindex $p 1]+$py}]
	}
	$surface create poly $plotpoints -outline {} -fill $color
    }
}

# How to construct the projection transform.
# This is instead of using a hokey hard-coded version
namespace eval transform {
    namespace import ::math::linearalgebra::*
    ::math::constants::constants pi
    proc make {angle scale offset} {
	variable pi
	set c [expr {cos($angle*$pi/180)}]
	set s [expr {sin($angle*$pi/180)}]
	set ms [expr {-$s}]
	set rotX [list {1.0 0.0 0.0} [list 0.0 $c $ms] [list 0.0 $s $c]]
	set rotY [list [list $c 0.0 $s] {0.0 1.0 0.0} [list $ms 0.0 $c]]
	set rotZ [list [list $c $s 0.0] [list $ms $c 0.0] {0.0 0.0 1.0}]
	set mat [scale $scale [mkIdentity 3]]
	set mat [matmul [matmul [matmul $mat $rotX] $rotY] $rotZ]
	return [list $mat $offset]
    }
}
### End of definitions

# Put the pieces together
pack [canvas .c -width 400 -height 400]
set cuboid [makeCuboid {2 3 4}]
set projection [transform::make 15 50 {100 100 100}]
drawShape .c $cuboid
