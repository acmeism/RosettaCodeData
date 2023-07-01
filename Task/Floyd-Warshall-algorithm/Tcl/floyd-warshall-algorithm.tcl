package require Tcl 8.5     ;# for {*} and [dict]
package require struct::graph
package require struct::graph::op

struct::graph g

set arclist {
    a b
    a p
    b m
    b c
    c d
    d e
    e f
    f q
    f g
}

g node insert {*}$arclist

foreach {from to} $arclist {
    set a [g arc insert $from $to]
    g arc setweight $a 1.0
}

set paths [::struct::graph::op::FloydWarshall g]

set paths [dict filter $paths key {a *}]        ;# filter for paths starting at "a"
set paths [dict filter $paths value {[0-9]*}]   ;# whose cost is not "Inf"
set paths [lsort -stride 2 -index 1 -real -decreasing $paths]   ;# and print the longest first
puts $paths
