package require Tcl 8.6

proc abc {word {blocks {BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM}}} {
    set abc {{letters blocks abc} {
	set rest [lassign $letters ch]
	set i 0
	foreach blk $blocks {
	    if {$ch in $blk && (![llength $rest]
		    || [apply $abc $rest [lreplace $blocks $i $i] $abc])} {
		return true
	    }
	    incr i
	}
	return false
    }}
    return [apply $abc [split $word ""] [lmap b $blocks {split $b ""}] $abc]
}

foreach word {"" A BARK BOOK TREAT COMMON SQUAD CONFUSE} {
    puts [format "Can we spell %9s? %s" '$word' [abc $word]]
}
