# This is how to declare functions - the mathematical entities - as opposed to procedures
proc function {name arguments body} {
    uplevel 1 [list proc tcl::mathfunc::$name $arguments [list expr $body]]
}

function double n {$n * 2}
function halve n {$n / 2}
function even n {($n & 1) == 0}
function mult {a b} {
    $a < 1 ? 0 :
    even($a) ? [logmult STRUCK] + mult(halve($a), double($b))
	     : [logmult KEPT]   + mult(halve($a), double($b)) + $b
}

# Wrapper to set up the logging
proc ethiopianMultiply {a b {tutor false}} {
    if {$tutor} {
	set wa [expr {[string length $a]+1}]
	set wb [expr {$wa+[string length $b]-1}]
	puts stderr "Ethiopian multiplication of $a and $b"
	interp alias {} logmult {} apply {{wa wb msg} {
	    upvar 1 a a b b
	    puts stderr [format "%*d %*d %s" $wa $a $wb $b $msg]
	    return 0
	}} $wa $wb
    } else {
	proc logmult args {return 0}
    }
    return [expr {mult($a,$b)}]
}
