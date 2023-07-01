proc range {b} {    ;# a common standard proc:  [range 5] -> {0 1 2 3 4}
    set a 0
    set res {}
    while {$a < $b} {
        lappend res $a
        incr a
    }
    return $res
}

# This proc builds up a nested foreach call, then evaluates it.
#
# The script is built up in $script, starting with the body using "%%" as
# a placeholder.
#
# For each die, a level is wrapped around it as follows:
#   set script {foreach d0 {1 2 3 4 5 6} $script}
#   set script {foreach d1 {1 2 3 4 5 6} $script}
#
# .. and {$d0 $d1 ..} are collected in the variable $vars, which is used
# to replace "%%" at the end.
#
# The script is evaluated with [try] - earlier Tcl's could use [catch] or [eval]
proc NdK {n {k 6}} {    ;# calculate a score histogram for $n dice of $k faces
    set sum {}
    set script {
        dict incr sum [::tcl::mathop::+ $n %%]   ;# add $n because ranges are 0-based
    }   ;# %% is a placeholder
    set vars ""
    for {set i 0} {$i < $n} {incr i} {
        set script [list foreach d$i [range $k] $script]
        append vars " \$d$i"
    }
    set script [string map [list %% $vars] $script]
    try $script
    return $sum
}

proc win_pr {p1 p2} {    ;# calculate the winning probability of player 1 given two score histograms
    set P 0
    set N 0
    dict for {d1 k1} $p1 {
        dict for {d2 k2} $p2 {
            set k [expr {$k1 * $k2}]
            incr N $k
            incr P [expr {$k * ($d1 > $d2)}]
        }
    }
    expr {$P * 1.0 / $N}
}

foreach {p1 p2} {
    {9 4}   {6 6}
    {5 10}  {6 7}
} {
    puts [format "p1 has %dd%d; p2 has %dd%d" {*}$p1 {*}$p2]
    puts [format " p1 wins with Pr(%s)" [win_pr [NdK {*}$p1] [NdK {*}$p2]]]
}
