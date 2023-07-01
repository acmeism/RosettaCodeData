package require TclOO
package provide x11 1

namespace eval ::x {
    namespace export {[a-z]*}
    namespace ensemble create
    variable mask
    array set mask {
	KeyPress	1
	KeyRelease	2
	ButtonPress	4
	ButtonRelease	8
    }

    proc display {script} {
	XOpenDisplay {}
	catch {uplevel 1 $script} msg opts
	XCloseDisplay
	return -options $opts $msg
    }
    proc eventloop {var handlers} {
	upvar 1 $var v
	while 1 {
	    set v [XNextEvent]
	    uplevel 1 [list switch [dict get $v type] $handlers]
	}
    }

    oo::class create window {
	variable w
        constructor {x y width height events} {
	    set m 0
	    variable ::x::mask
	    foreach e $events {catch {incr m $mask($e)}}
	    set w [XCreateSimpleWindow $x $y $width $height $m]
	}
	method map {} {
	    XMapWindow $w
	}
	method unmap {} {
	    XUnmapWindow $w
	}
	method fill {x y width height} {
	    XFillRectangle $w $x $y $width $height
	}
	method text {x y string} {
	    XDrawString $w $x $y $string
	}
	destructor {
	    XDestroyWindow $w
	}
    }
}
