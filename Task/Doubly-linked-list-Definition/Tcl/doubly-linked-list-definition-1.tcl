package require Tcl 8.4
proc dl {_name cmd {where error} {value ""}} {
    upvar 1 $_name N
    switch -- $cmd {
        insert {
            if ![info exists N()] {set N() {"" "" 0}}
            set id [lindex $N() 2]
            lset N() 2 [incr id]
            switch -- $where {
                head {
                    set prev {}
                    set next [lindex $N() 0]
                    lset N() 0 $id
                }
                end {
                    set prev [lindex $N() 1]
                    set next {}
                    lset N() 1 $id
                }
                default {
                    set prev $where
                    set next [lindex $N($where) 1]
                    lset N($where) 1 $id
                }
            }
            if {$prev ne ""} {lset N($prev) 1 $id}
            if {$next ne ""} {lset N($next) 0 $id}
            if {[lindex $N() 1] eq ""} {lset N() 1 $id}
            set N($id) [list $prev $next $value]
            return $id
        }
        delete {
            set i $where
            if {$where eq "head"} {set i [dl N head]}
            if {$where eq "end"}  {set i [dl N end]}
            foreach {prev next} $N($i) break
            if {$prev ne ""} {lset N($prev) 1 $next}
            if {$next ne ""} {lset N($next) 0 $prev}
            if {[dl N head] == $i} {lset N() 0 $next}
            if {[dl N end] == $i}  {lset N() 1 $prev}
            unset N($i)
        }
        findfrom {
            if {$where eq "head"} {set where [dl N head]}
            for {set i $where} {$i ne ""} {set i [dl N next $i]} {
                if {[dl N get $i] eq $value} {return $i}
            }
        }
        get    {lindex $N($where) 2}
        set    {lset   N($where) 2 $value; set value}
        head   {lindex $N() 0}
        end    {lindex $N() 1}
        next   {lindex $N($where) 1}
        prev   {lindex $N($where) 0}
        length {expr {[array size N]-1}}
        asList {
            set res {}
            for {set i [dl N head]} {$i ne ""} {set i [dl N next $i]} {
                lappend res [dl N get $i]
            }
            return $res
        }
        asList2 {
            set res {}
            for {set i [dl N end]} {$i ne ""} {set i [dl N prev $i]} {
                lappend res [dl N get $i]
            }
            return $res
        }
    }
}
