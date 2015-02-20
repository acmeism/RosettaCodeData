package require TclOO

oo::class create KDTree {
    variable t dim
    constructor {points} {
	set t [my Build 0 $points 0 end]
	set dim [llength [lindex $points 0]]
    }
    method Build {split exset from to} {
	set exset [lsort -index $split -real [lrange $exset $from $to]]
	if {![llength $exset]} {return 0}
	set m [expr {[llength $exset] / 2}]
	set d [lindex $exset $m]
	while {[set mm $m;incr mm] < [llength $exset] && \
		[lindex $exset $mm $split] == [lindex $d $split]} {
	    set m $mm
	}
	set s [expr {($split + 1) % [llength $d]}]
	list 1 $d $split [my Build $s $exset 0 [expr {$m-1}]] \
		[my Build $s $exset [expr {$m+1}] end]
    }

    method findNearest {p} {
	lassign [my FN $t $p inf] p d2 count
	return [list $p [expr {sqrt($d2)}] $count]
    }
    method FN {kd target maxDist2} {
	if {[lindex $kd 0] == 0} {
	    return [list [lrepeat $dim 0.0] inf 0]
	}

	set nodesVisited 1
	lassign $kd -> pivot s

	if {[lindex $target $s] <= [lindex $pivot $s]} {
	    set nearerKD [lindex $kd 3]
	    set furtherKD [lindex $kd 4]
	} else {
	    set nearerKD [lindex $kd 4]
	    set furtherKD [lindex $kd 3]
	}

	lassign [my FN $nearerKD $target $maxDist2] nearest dist2 count
	incr nodesVisited $count

	if {$dist2 < $maxDist2} {
	    set maxDist2 $dist2
	}
	set d2 [expr {([lindex $pivot $s]-[lindex $target $s])**2}]
	if {$d2 > $maxDist2} {
	    return [list $nearest $dist2 $nodesVisited]
	}
	set d2 0.0
	foreach pp $pivot tp $target {set d2 [expr {$d2+($pp-$tp)**2}]}
	if {$d2 < $dist2} {
	    set nearest $pivot
	    set maxDist2 [set dist2 $d2]
	}

	lassign [my FN $furtherKD $target $maxDist2] fNearest fDist2 count
	incr nodesVisited $count
	if {$fDist2 < $dist2} {
	    set nearest $fNearest
	    set dist2 $fDist2
	}

	return [list $nearest $dist2 $nodesVisited]
    }
}
