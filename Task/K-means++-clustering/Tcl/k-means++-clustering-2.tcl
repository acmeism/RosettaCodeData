package require Tk
image create photo disp -width 400 -height 400
pack [label .l -image disp]
update
proc plot {x y color} {
    disp put $color -to [expr {int(200+19.9*$x)}] [expr {int(200+19.9*$y)}]
}
apply {{} {
    set POINTS [genXY 100000 10]
    set CENTROIDS [lloyd POINTS 11]
    foreach c $CENTROIDS {
	lappend colors [list [list [format "#%02x%02x%02x" \
		[expr {64+int(128*rand())}] [expr {64+int(128*rand())}] \
		[expr {64+int(128*rand())}]]]]
    }
    foreach pt $POINTS {
	lassign $pt px py group
	plot $px $py [lindex $colors $group]
    }
    foreach c $CENTROIDS {
	lassign $c cx cy group
	plot $cx $cy black
    }
}}
