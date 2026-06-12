package require Tcl 8.6

# Helpers
proc aspipe {input cmd args} {
    tailcall coroutine pipe[incr ::pipes] eval {yield [info coroutine];} \
	[list $cmd $input {*}$args] {;break}
}
proc forpipe {input var body} {
    upvar 1 $var v
    while {[llength [info commands $input]]} {
	set v [$input]
	uplevel 1 $body
    }
}

# Pipeline framework; parses, collects results as newline-separated lines
proc pipeline args {
    if {![llength $args]} {error "no pipeline components"}
    set p [aspipe {} eval {while {[gets stdin line]>=0} {yield $line}}]
    set oi -1
    foreach ni [lsearch -all [lappend args "|"] "|"] {
	set cmd [lrange $args [expr {$oi+1}] [expr {$ni-1}]]
	set p [aspipe $p {*}$cmd]
	set oi $ni
    }
    set accum {}
    forpipe $p line {
	lappend accum $line
    }
    return [join $accum \n]
}

# Pipeline implementations - redirections
proc << {in args} {
    foreach string $args {
	foreach line [split $string "\n"] {
	    yield $line
	}
    }
}
proc < {in filename} {
    set f [open $filename]
    while {[gets $f line] >= 0} {
	yield $line
    }
    close $f
}
proc > {in filename} {
    set f [open $filename w]
    forpipe $in line {
	puts $f $line
    }
    close $f
}
proc >> {in filename} {
    set f [open $filename a]
    forpipe $in line {
	puts $f $line
    }
    close $f
}

# Pipeline implementations - "commands"
proc cat {in args} {
    foreach filename $args {
	if {$filename eq "-"} {
	    forpipe $in line {
		yield $line
	    }
	} else {
	    set f [open $filename]
	    while {[gets $f line] >= 0} {
		yield $line
	    }
	    close $f
	}
    }
}
proc head {in count} {
    forpipe $in line {
	if {[incr i] <= $count} {
	    yield $line
	}
    }
}
proc tail {in count} {
    incr count -1
    set accum {}
    forpipe $in line {
	set accum [lrange [lappend accum $line] end-$count end]
    }
    foreach item $accum {yield $item}
}
proc grep {in RE} {
    forpipe $in line {
	if {[regexp $RE $line]} {yield $line}
    }
}
proc sort {in} {
    set accum {}
    forpipe $in line {
	lappend accum $line
    }
    foreach line [lsort $accum] {yield $line}
}
proc uniq {in} {
    forpipe $in line {
	if {![info exists prev] || $prev ne $line} {
	    yield $line
	}
	set prev $line
    }
}
proc wc {in {type "words"}} {
    set count 0
    switch $type {
	words { set RE {\S+} }
	lines { set RE {.*}  }
    }
    forpipe $in line {
	incr count [regexp -all $RE $line]
    }
    yield $count
}
proc tee {in filename} {
    set f [open $filename w]
    forpipe $in line {
	puts $f $line
	yield $line
    }
    close $f
}
