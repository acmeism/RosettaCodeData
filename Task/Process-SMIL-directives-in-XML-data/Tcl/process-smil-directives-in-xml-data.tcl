package require Tcl 8.6
package require tdom

# Applies a time-based interpolation to generate a space-separated list
proc interpolate {time info} {
    dict with info {
	scan $begin "%fs" begin
	scan $dur "%fs" dur
    }
    if {$time < $begin} {
	return $from
    } elseif {$time > $begin+$dur} {
	return $to
    }
    set delta [expr {($time - $begin) / $dur}]
    return [lmap f $from t $to {expr {$f + ($t-$f)*$delta}}]
}

# Applies SMIL <transform> elements to their container
proc applySMILtransform {sourceDocument time} {
    set doc [dom parse [$sourceDocument asXML]]
    foreach smil [$doc selectNodes //smil] {
	foreach context [$smil selectNodes {//*[animate]}] {
	    set animator [$context selectNodes animate]
	    set animated [$context selectNodes @[$animator @attributeName]]
	    $context removeChild $animator
	    $context setAttribute [$animator @attributeName] \
		[interpolate $time [lindex [$animator asList] 1]]
	}
	if {[$smil parentNode] eq ""} {
	    set reparent 1
	} else {
	    [$smil parentNode] replaceChild $smil [$smil firstChild]
	}
    }
    if {[info exist reparent]} {
	set doc [dom parse [[$smil firstChild] asXML]]
    }
    return $doc
}

set t [expr {[lindex $argv 0] + 0.0}]
set result [applySMILtransform [dom parse [read stdin]] $t]
puts {<?xml version="1.0" ?>}
puts -nonewline [$result asXML -indent 2]
