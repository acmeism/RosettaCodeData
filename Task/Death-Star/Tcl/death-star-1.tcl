package require Tcl 8.5

proc normalize vec {
    upvar 1 $vec v
    lassign $v x y z
    set len [expr {sqrt($x**2 + $y**2 + $z**2)}]
    set v [list [expr {$x/$len}] [expr {$y/$len}] [expr {$z/$len}]]
    return
}

proc dot {a b} {
    lassign $a ax ay az
    lassign $b bx by bz
    return [expr {-($ax*$bx + $ay*$by + $az*$bz)}]
}

# Intersection code; assumes that the vector is parallel to the Z-axis
proc hitSphere {sphere x y z1 z2} {
    dict with sphere {
	set x [expr {$x - $cx}]
	set y [expr {$y - $cy}]
	set zsq [expr {$r**2 - $x**2 - $y**2}]
	if {$zsq < 0} {return 0}
	upvar 1 $z1 _1 $z2 _2
	set zsq [expr {sqrt($zsq)}]
	set _1 [expr {$cz - $zsq}]
	set _2 [expr {$cz + $zsq}]
	return 1
    }
}

# How to do the intersection with our scene
proc intersectDeathStar {x y vecName} {
    global big small
    if {![hitSphere $big $x $y zb1 zb2]} {
	# ray lands in blank space
	return 0
    }
    upvar 1 $vecName vec
    # ray hits big sphere; check if it hit the small one first
    set vec [if {
	![hitSphere $small $x $y zs1 zs2] || $zs1 > $zb1 || $zs2 <= $zb1
    } then {
	dict with big {
	    list [expr {$x - $cx}] [expr {$y - $cy}] [expr {$zb1 - $cz}]
	}
    } else {
	dict with small {
	    list [expr {$cx - $x}] [expr {$cy - $y}] [expr {$cz - $zs2}]
	}
    }]
    normalize vec
    return 1
}

# Intensity calculators for different lighting components
proc diffuse {k intensity L N} {
    expr {[dot $L $N] ** $k * $intensity}
}
proc specular {k intensity L N S} {
    # Calculate reflection vector
    set r [expr {2 * [dot $L $N]}]
    foreach l $L n $N {lappend R [expr {$l-$r*$n}]}
    normalize R
    # Calculate the specular reflection term
    return [expr {[dot $R $S] ** $k * $intensity}]
}

# Simple raytracing engine that uses parallel rays
proc raytraceEngine {diffparms specparms ambient intersector shades renderer fx tx sx fy ty sy} {
    global light
    for {set y $fy} {$y <= $ty} {set y [expr {$y + $sy}]} {
	set line {}
	for {set x $fx} {$x <= $tx} {set x [expr {$x + $sx}]} {
	    if {![$intersector $x $y vec]} {
		# ray lands in blank space
		set intensity end
	    } else {
		# ray hits something; we've got the normalized vector
		set b [expr {
		    [diffuse {*}$diffparms $light $vec]
		    + [specular {*}$specparms $light $vec {0 0 -1}]
		    + $ambient
		}]
		set intensity [expr {int((1-$b) * ([llength $shades]-1))}]
		if {$intensity < 0} {
		    set intensity 0
		} elseif {$intensity >= [llength $shades]-1} {
		    set intensity end-1
		}
	    }
	    lappend line [lindex $shades $intensity]
	}
	{*}$renderer $line
    }
}

# The general scene settings
set light {-50 30 50}
set big   {cx 20 cy 20 cz 0   r 20}
set small {cx 7  cy 7  cz -10 r 15}
normalize light

# Render as text
proc textDeathStar {diff spec lightBrightness ambient} {
    global big
    dict with big {
	raytraceEngine [list $diff $lightBrightness] \
	    [list $spec $lightBrightness] $ambient intersectDeathStar \
	    [split ".:!*oe&#%@ " {}] {apply {l {puts [join $l ""]}}} \
	    [expr {$cx+floor(-$r)}] [expr {$cx+ceil($r)+0.5}] 0.5 \
	    [expr {$cy+floor(-$r)+0.5}] [expr {$cy+ceil($r)+0.5}] 1
    }
}
textDeathStar 3 10 0.7 0.3
