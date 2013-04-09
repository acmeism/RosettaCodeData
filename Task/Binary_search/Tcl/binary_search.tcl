proc binSrch {lst x} {
    set len [llength $lst]
    if {$len == 0} {
        return -1
    } else {
        set pivotIndex [expr {$len / 2}]
        set pivotValue [lindex $lst $pivotIndex]
        if {$pivotValue == $x} {
            return $pivotIndex
        } elseif {$pivotValue < $x} {
            set recursive [binSrch [lrange $lst $pivotIndex+1 end] $x]
            return [expr {$recursive > -1 ? $recursive + $pivotIndex + 1 : -1}]
        } elseif {$pivotValue > $x} {
            set recursive [binSrch [lrange $lst 0 $pivotIndex-1] $x]
            return [expr {$recursive > -1 ? $recursive : -1}]
        }
    }
}
proc binary_search {lst x} {
    if {[set idx [binSrch $lst $x]] == -1} {
        puts "element $x not found in list"
    } else {
        puts "element $x found at index $idx"
    }
}
