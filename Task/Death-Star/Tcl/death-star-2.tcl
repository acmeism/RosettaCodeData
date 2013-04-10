# Render as a picture (with many hard-coded settings)
package require Tk
proc guiDeathStar {photo diff spec lightBrightness ambient} {
    set row 0
    for {set i 255} {$i>=0} {incr i -1} {
	lappend shades [format "#%02x%02x%02x" $i $i $i]
    }
    raytraceEngine [list $diff $lightBrightness] \
	[list $spec $lightBrightness] $ambient intersectDeathStar \
	$shades {apply {l {
	    upvar 2 photo photo row row
	    $photo put [list $l] -to 0 $row
	    incr row
	    update
	}}} 0 40 0.0625 0 40 0.0625
}
pack [label .l -image [image create photo ds]]
guiDeathStar ds 3 10 0.7 0.3
