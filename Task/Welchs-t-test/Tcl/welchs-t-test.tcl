#!/usr/bin/tclsh

package require math::statistics
package require math::special
namespace path {::math::statistics ::math::special ::tcl::mathfunc ::tcl::mathop}

proc incf {_var {inc 1.0}} {
    upvar 1 $_var var
    if {![info exists var]} {
        set var 0.0
    }
    set var [expr {$inc + $var}]
}

proc sumfor {_var A B body} {
    upvar 1 $_var var
    set var $A
    set res 0
    while {$var < $B} {
        incf res [uplevel 1 $body]
        incr var
    }
    return $res
}

proc sqr {x} {expr {$x*$x}}

proc pValue {S1 S2 {n 11000}} {
    set σ²1 [var $S1]
    set σ²2 [var $S2]
    set N1  [llength $S1]
    set N2  [llength $S2]
    set σ²/sz1 [/ ${σ²1} $N1]
    set σ²/sz2 [/ ${σ²2} $N2]

    set d1 [/ [sqr ${σ²1}] [* [sqr $N1] [- $N1 1]]]
    set d2 [/ [sqr ${σ²2}] [* [sqr $N2] [- $N2 1]]]
    set DoF [/ [sqr [+ ${σ²/sz1} ${σ²/sz2}]] [+ $d1 $d2]]

    set a [/ $DoF 2.0]

    set welchTstat [/ [- [mean $S1] [mean $S2]] [sqrt [+ ${σ²/sz1} ${σ²/sz2}]]]
    set x [/ $DoF [+ [sqr $welchTstat] $DoF]]
    set h [/ $x $n]

    / [* [/ $h 6] \
         [+ [* [** $x [- $a 1]] \
               [** [- 1 $x] -0.5]] \
            [* 4 [sumfor i 0 $n {
                    * [** [+ [* $h $i] [/ $h 2]] [- $a 1]] \
                      [** [- 1 [* $h $i] [/ $h 2]] -0.5]}]] \
            [* 2 [sumfor i 0 $n {
                    * [** [* $h $i] [- $a 1]] [** [- 1 [* $h $i]] -0.5]}]]]] \
      [* [Gamma $a] 1.77245385090551610 [/ 1.0 [Gamma [+ $a 0.5]]]]
}


foreach {left right} {
    { 27.5 21.0 19.0 23.6 17.0 17.9 16.9 20.1 21.9 22.6 23.1 19.6 19.0 21.7 21.4 }
    { 27.1 22.0 20.8 23.4 23.4 23.5 25.8 22.0 24.8 20.2 21.9 22.1 22.9 20.5 24.4 }

    { 17.2 20.9 22.6 18.1 21.7 21.4 23.5 24.2 14.7 21.8 }
    { 21.5 22.8 21.0 23.0 21.6 23.6 22.5 20.7 23.4 21.8 20.7 21.7 21.5 22.5 23.6 21.5 22.5 23.5 21.5 21.8 }

    { 19.8 20.4 19.6 17.8 18.5 18.9 18.3 18.9 19.5 22.0 }
    { 28.2 26.6 20.1 23.3 25.2 22.1 17.7 27.6 20.6 13.7 23.2 17.5 20.6 18.0 23.9 21.6 24.3 20.4 24.0 13.2 }

    { 30.02 29.99 30.11 29.97 30.01 29.99 }
    { 29.89 29.93 29.72 29.98 30.02 29.98 }

    { 3.0 4.0 1.0 2.1 }
    { 490.2 340.0 433.9 }
} {
    puts [pValue $left $right]
}
