package require Tcl 8.6
package require generator

generator define nonoblocks {blocks cells} {
    set sum [tcl::mathop::+ {*}$blocks]
    if {$sum == 0 || [lindex $blocks 0] == 0} {
	generator yield {{0 0}}
	return
    } elseif {$sum + [llength $blocks] - 1 > $cells} {
	error "those blocks will not fit in those cells"
    }

    set brest [lassign $blocks blen]
    for {set bpos 0} {$bpos <= $cells - $sum - [llength $brest]} {incr bpos} {
	if {![llength $brest]} {
	    generator yield [list [list $bpos $blen]]
	    return
	}
	set offset [expr {$bpos + $blen + 1}]
	generator foreach subpos [nonoblocks $brest [expr {$cells - $offset}]] {
	    generator yield [linsert [lmap b $subpos {
		lset b 0 [expr {[lindex $b 0] + $offset}]
	    }] 0 [list $bpos $blen]]
	}
    }
}

if {[info script] eq $::argv0} {
    proc pblock {cells {vec {}}} {
	set vector [lrepeat $cells "_"]
	set ch 64
	foreach b $vec {
	    incr ch
	    lassign $b bp bl
	    for {set i $bp} {$i < $bp + $bl} {incr i} {
		lset vector $i [format %c $ch]
	    }
	}
	return |[join $vector "|"]|
    }
    proc flist {items} {
	return [format "\[%s\]" [join $items ", "]]
    }
    foreach {blocks cells} {
	{2 1} 5
	{} 5
	{8} 10
	{2 3 2 3} 15
	{2 3} 5
    } {
	puts "\nConfiguration:"
	puts [format "%s # %d cells and %s blocks" \
		  [pblock $cells] $cells [flist $blocks]]
	puts "  Possibilities:"
	set i 0
	try {
	    generator foreach vector [nonoblocks $blocks $cells] {
		puts "    [pblock $cells $vector]"
		incr i
	    }
	    puts "  A total of $i possible configurations"
	} on error msg {
	    puts "    --> ERROR: $msg"
	}
    }
}

package provide nonoblock 1
