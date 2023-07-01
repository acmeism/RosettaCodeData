# matrix operation support:
package require math::linearalgebra
namespace import ::math::linearalgebra::matmul
namespace import ::math::linearalgebra::crossproduct
namespace import ::math::linearalgebra::dotproduct
namespace import ::math::linearalgebra::sub

# returns a cube as a list of faces,
# where each face is a list of (3space) points
proc make_cube {{radius 1}} {
    set dirs {
        A { 1  1  1}
        B { 1  1 -1}
        C { 1 -1 -1}
        D { 1 -1  1}
        E {-1  1  1}
        F {-1  1 -1}
        G {-1 -1 -1}
        H {-1 -1  1}
    }
    set faces {
        {A B C D}
        {D C G H}
        {H G F E}
        {E F B A}
        {A D H E}
        {C B F G}
    }
    lmap fa $faces {
        lmap dir $fa {
            lmap x [dict get $dirs $dir] {
                expr {1.0 * $x * $radius}
            }
        }
    }
}

# a matrix constructor
proc Matrix {m} {
    tailcall lmap row $m {
        lmap e $row {
            expr 1.0*($e)
        }
    }
}

proc identity {} {
    Matrix {
        {1 0 0}
        {0 1 0}
        {0 0 1}
    }
}

# some matrices useful for animation:
proc rotateZ {theta} {
    Matrix {
        { cos($theta) -sin($theta)  0 }
        { sin($theta)  cos($theta)  0 }
        { 0            0            1 }
    }
}
proc rotateY {theta} {
    Matrix {
        { sin($theta)  0  cos($theta) }
        { 0            1            0 }
        { cos($theta)  0 -sin($theta) }
    }
}
proc rotateX {theta} {
    Matrix {
        { 1            0            0 }
        { 0  cos($theta) -sin($theta) }
        { 0  sin($theta)  cos($theta) }
    }
}

proc camera {flen} {
    Matrix {
        { $flen  0      0 }
        { 0      $flen  0 }
        { 0      0      0 }
    }
}

proc render {canvas object} {

    set W   [winfo width  $canvas]
    set H   [winfo height $canvas]

    set fl  1.0
    set t   [expr {[clock microseconds] / 1000000.0}]

    set transform [identity]
    set transform [matmul $transform [rotateX [expr {atan(1)}]]]
    set transform [matmul $transform [rotateZ [expr {atan(1)}]]]

    set transform [matmul $transform [rotateY $t]]
    set transform [matmul $transform [camera $fl]]

    foreach face $object {
        # do transformations into screen space:
        set points [lmap p $face { matmul $p $transform }]
        # calculate a normal
        set o       [lindex $points 0]
        set v1 [sub [lindex $points 1] $o]
        set v2 [sub [lindex $points 2] $o]
        set normal [crossproduct $v1 $v2]

        set cosi   [dotproduct $normal {0 0 -1.0}]
        if {$cosi <= 0} { ;# rear-facing!
            continue
        }

        set points [lmap p $points {
            lassign $p x y
            list [expr {$x + $W/2}] [expr {$y + $H/2}]
        }]
        set points [concat {*}$points]
        $canvas create poly $points -outline black -fill red
    }
}

package require Tk
pack [canvas .c] -expand yes -fill both

proc tick {} {
    .c delete all
    render .c $::world
    after 50 tick
}
set ::world [make_cube 100]
tick
