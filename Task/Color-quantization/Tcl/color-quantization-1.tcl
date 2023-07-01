package require Tcl 8.6
package require Tk

proc makeCluster {pixels} {
    set rmin [set rmax [lindex $pixels 0 0]]
    set gmin [set gmax [lindex $pixels 0 1]]
    set bmin [set bmax [lindex $pixels 0 2]]
    set rsum [set gsum [set bsum 0]]
    foreach p $pixels {
	lassign $p r g b
	if {$r<$rmin} {set rmin $r} elseif {$r>$rmax} {set rmax $r}
	if {$g<$gmin} {set gmin $g} elseif {$g>$gmax} {set gmax $g}
	if {$b<$bmin} {set bmin $b} elseif {$b>$bmax} {set bmax $b}
	incr rsum $r
	incr gsum $g
	incr bsum $b
    }
    set n [llength $pixels]
    list [expr {double($n)*($rmax-$rmin)*($gmax-$gmin)*($bmax-$bmin)}] \
	[list [expr {$rsum/$n}] [expr {$gsum/$n}] [expr {$bsum/$n}]] \
	[list [expr {$rmax-$rmin}] [expr {$gmax-$gmin}] [expr {$bmax-$bmin}]] \
	$pixels
}

proc colorQuant {img n} {
    set width  [image width  $img]
    set height [image height $img]
    # Extract the pixels from the image
    for {set x 0} {$x < $width} {incr x} {
	for {set y 0} {$y < $height} {incr y} {
	    lappend pixels [$img get $x $y]
	}
    }
    # Divide pixels into clusters
    for {set cs [list [makeCluster $pixels]]} {[llength $cs] < $n} {} {
	set cs [lsort -real -index 0 $cs]
	lassign [lindex $cs end] score centroid volume pixels
	lassign $centroid cr cg cb
	lassign $volume vr vg vb
	while 1 {
	    set p1 [set p2 {}]
	    if {$vr>$vg && $vr>$vb} {
		foreach p $pixels {
		    if {[lindex $p 0]<$cr} {lappend p1 $p} {lappend p2 $p}
		}
	    } elseif {$vg>$vb} {
		foreach p $pixels {
		    if {[lindex $p 1]<$cg} {lappend p1 $p} {lappend p2 $p}
		}
	    } else {
		foreach p $pixels {
		    if {[lindex $p 2]<$cb} {lappend p1 $p} {lappend p2 $p}
		}
	    }
	    if {[llength $p1] && [llength $p2]} break
	    # Partition failed! Perturb partition point away from the centroid and try again
	    set cr [expr {$cr + 20*rand() - 10}]
	    set cg [expr {$cg + 20*rand() - 10}]
	    set cb [expr {$cb + 20*rand() - 10}]
	}
	set cs [lreplace $cs end end [makeCluster $p1] [makeCluster $p2]]
    }
    # Produce map from pixel values to quantized values
    foreach c $cs {
	set centroid [format "#%02x%02x%02x" {*}[lindex $c 1]]
	foreach p [lindex $c end] {
	    set map($p) $centroid
	}
    }
    # Remap the source image
    set newimg [image create photo -width $width -height $height]
    for {set x 0} {$x < $width} {incr x} {
	for {set y 0} {$y < $height} {incr y} {
	    $newimg put $map([$img get $x $y]) -to $x $y
	}
    }
    return $newimg
}
