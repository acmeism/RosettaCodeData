# tailcall optimization is standard in tcl8.6
proc fact { n { result 1. } } {
    if { $n <= 1 } {
        return $result
    } else {
        tailcall fact [expr {$n-1}] [expr {$n*$result}]
    }
}

set  f [fact 10]

puts $f
