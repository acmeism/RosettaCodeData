package require Tcl 8.6
oo::class create Config {
    variable filename contents
    constructor fileName {
	set filename $fileName
	set contents {}
	try {
	    set f [open $filename]
	    ### Sanitize during input
	    foreach line [split [read $f] \n] {
		if {[string match "#*" $line]} {
		    lappend contents $line
		    continue
		}
		if {[regexp {^;\W*$} $line]} continue
		set line [string trim [regsub -all {[^\u0020-\u007e]} $line {}]]
		if {[regexp {^(\W*)(\w+)(.*)$} $line -> a b c]} {
		    set line "[regsub -all {^;+} $a {;}][string toupper $b]$c"
		}
		lappend contents $line
	    }
	} finally {
	    if {[info exists f]} {
		close $f
	    }
	}
    }
    method save {} {
	set f [open $filename w]
	puts $f [join $contents \n]
	close $f
    }

    # Utility methods (not exposed API)
    method Transform {pattern vars replacement} {
	set matched 0
	set line -1
	set RE "(?i)^$pattern$"
	foreach l $contents {
	    incr line
	    if {[uplevel 1 [list regexp $RE $l -> {*}$vars]]} {
		if {$matched} {
		    set contents [lreplace $contents $line $line]
		    incr line -1
		} else {
		    lset contents $line [uplevel 1 [list subst $replacement]]
		}
		set matched 1
	    }
	}
	return $matched
    }
    method Format {k v} {
	set v " [string trimleft $v]"
	return "[string toupper $k][string trimright $v]"
    }

    # Public API for modifying options
    method enable {option} {
	if {![my Transform ";?\\s*($option)\\M\s*(.*)" {k v} \
		  {[my Format $k $v]}]} {
	    lappend contents [my Format $option ""]
	}
    }
    method disable {option} {
	if {![my Transform ";?\\s*($option)\\M\s*(.*)" {k v} \
		  {; [my Format $k $v]}]} {
	    lappend contents "; [my Format $option ""]"
	}
    }
    method set {option {value ""}} {
	if {![my Transform ";?\\s*($option)\\M.*" k {[my Format $k $value]}]} {
	    lappend contents [my Format $option $value]
	}
    }
}
