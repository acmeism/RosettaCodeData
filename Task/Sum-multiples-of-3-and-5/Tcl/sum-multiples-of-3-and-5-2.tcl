# Smart version; no iteration so very scalable!
proc tcl::mathfunc::triangle {n} {expr {
    $n * ($n+1) / 2
}}
# Note that the rounding on integer division is exactly what we need here.
proc sum35 {n} {
    incr n -1
    expr {3*triangle($n/3) + 5*triangle($n/5) - 15*triangle($n/15)}
}
