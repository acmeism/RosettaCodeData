package require Tcl 8.5
proc topsort {data} {
    # Clean the data
    dict for {node depends} $data {
        if {[set i [lsearch -exact $depends $node]] >= 0} {
            set depends [lreplace $depends $i $i]
            dict set data $node $depends
        }
        foreach node $depends {dict lappend data $node}
    }
    # Do the sort
    set sorted {}
    while 1 {
        # Find available nodes
        set avail [dict keys [dict filter $data value {}]]
        if {![llength $avail]} {
            if {[dict size $data]} {
                error "graph is cyclic, possibly involving nodes \"[dict keys $data]\""
            }
            return $sorted
        }
        lappend sorted $avail   ;# change here: [[Topological sort]] had {*}$avail
        # Remove from working copy of graph
        dict for {node depends} $data {
            foreach n $avail {
                if {[set i [lsearch -exact $depends $n]] >= 0} {
                    set depends [lreplace $depends $i $i]
                    dict set data $node $depends
                }
            }
        }
        foreach node $avail {
            dict unset data $node
        }
    }
}

# The changes to $data in this proc offer an interesting reflection on value semantics.
# Consider the value of $data seen by [dict for], by each invocation of [dict keys]
# and [dict unset] and how that affects the soundness of the loops.
proc tops {data} {
    dict for {k v} $data {
        foreach t [dict keys $data] {
            if {$t in $v} {
                dict unset data $t
            }
        }
    }
    dict keys $data
}

proc withdeps {dict tops {res {}}} {
    foreach top $tops {
        if {[dict exists $dict $top]} {
            set deps [dict get $dict $top]
            set res [dict merge  $res  [dict create $top $deps]  [withdeps $dict $deps]]
        }
    }
    return $res
}

proc parsetop {t} {
    set top {}
    foreach l [split $t \n] {
        catch {dict lappend top {*}$l}
    }
    return $top
}

set inputData {
        top1    des1 ip1 ip2
        top2    des1 ip2 ip3
        ip1     extra1 ip1a ipcommon
        ip2     ip2a ip2b ip2c ipcommon
        des1    des1a des1b des1c
        des1a   des1a1 des1a2
        des1c   des1c1 extra1
}

set d [parsetop $inputData]
pdict $d
set tops [tops $d]

puts "Tops: $tops\n"

set targets [list $tops {*}$tops]
foreach target $targets {
    puts "Target: $target"
    set i 0
    foreach deps [topsort [withdeps $d $target]] {
        puts "\tround [incr i]:\t$deps"
    }
}
