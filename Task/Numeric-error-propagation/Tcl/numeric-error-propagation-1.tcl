package require Tcl 8.6
oo::class create RAII-support {
    constructor {} {
	upvar 1 { end } end
	lappend end [self]
	trace add variable end unset [namespace code {my DieNicely}]
    }
    destructor {
	catch {
	    upvar 1 { end } end
	    trace remove variable end unset [namespace code {my DieNicely}]
	}
    }
    method return {{level 1}} {
	incr level
	upvar 1 { end } end
	upvar $level { end } parent
	trace remove variable end unset [namespace code {my DieNicely}]
	lappend parent [self]
	trace add variable parent unset [namespace code {my DieNicely}]
	return -level $level [self]
    }
    # Swallows arguments
    method DieNicely args {tailcall my destroy}
}
oo::class create RAII-class {
    superclass oo::class
    method return args {
	[my new {*}$args] return 2
    }
    method unknown {m args} {
	if {[string is double -strict $m]} {
	    return [tailcall my new $m {*}$args]
	}
	next $m {*}$args
    }
    unexport create unknown
    self method create args {
	set c [next {*}$args]
	oo::define $c superclass {*}[info class superclass $c] RAII-support
	return $c
    }
}
# Makes a convenient scope for limiting RAII lifetimes
proc scope {script} {
    foreach v [info global] {
	if {[array exists ::$v] || [string match { * } $v]} continue
	lappend vars $v
	lappend vals [set ::$v]
    }
    tailcall apply [list $vars [list \
	try $script on ok msg {$msg return}
    ] [uplevel 1 {namespace current}]] {*}$vals
}
