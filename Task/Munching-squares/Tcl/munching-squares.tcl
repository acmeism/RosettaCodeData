package require Tk

proc xorImage {img table} {
    set data {}
    set h [image height $img]
    set w [image width $img]
    for {set y 0} {$y < $h} {incr y} {
	set row {}
	for {set x 0} {$x < $w} {incr x} {
	    lappend row [lindex $table [expr {($x^$y) % [llength $table]}]]
	}
	lappend data $row
    }
    $img put $data
}
proc inRange {i f t} {expr {$f + ($t-$f)*$i/255}}
proc mkTable {rf rt gf gt bf bt} {
    for {set i 0} {$i < 256} {incr i} {
	lappend tbl [format "#%02x%02x%02x" \
	    [inRange $i $rf $rt] [inRange $i $gf $gt] [inRange $i $bf $bt]]
    }
    return $tbl
}

set img [image create photo -width 512 -height 512]
xorImage $img [mkTable 0 255 64 192 255 0]
pack [label .l -image $img]
