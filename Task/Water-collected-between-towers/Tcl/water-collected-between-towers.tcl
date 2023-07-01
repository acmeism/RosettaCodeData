namespace path {::tcl::mathfunc ::tcl::mathop}

proc flood {ground} {
    set lefts [
        set d 0
        lmap g $ground {
            set d [max $d $g]
        }
    ]
    set ground [lreverse $ground]
    set rights [
        set d 0
        lmap g $ground {
            set d [max $d $g]
        }
    ]
    set rights [lreverse $rights]
    set ground [lreverse $ground]
    set water [lmap l $lefts r $rights {min $l $r}]
    set depths [lmap g $ground w $water {- $w $g}]
    + {*}$depths
}

foreach p {
    {5 3 7 2 6 4 5 9 1 2}
    {1 5 3 7 2}
    {5 3 7 2 6 4 5 9 1 2}
    {2 6 3 5 2 8 1 4 2 2 5 3 5 7 4 1}
    {5 5 5 5}
    {5 6 7 8}
    {8 7 7 6}
    {6 7 10 7 6}
} {
    puts [flood $p]:\t$p
}
