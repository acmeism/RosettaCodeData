# Procedure named ".." returns list of integers from 1 to max.
proc .. max {
  for {set i 1} {$i <= $max} {incr i} {
    lappend l $i
  }
  return $l
}


# Procedure named "..." returns list of n lists of integers from 1 to max.
proc ... {max n} {
  foreach i [.. $n] {
    lappend result [.. $max]
  }
  return $result
}

# Procedure named "crossProduct" returns cross product of lists
proc crossProduct {listOfLists} {
  set result [list [list]]
  foreach factor $listOfLists {
    set newResult {}
    foreach combination $result {
      foreach elt $factor {
        lappend newResult [linsert $combination end $elt]
      }
    }
    set result $newResult
  }
  return $result
}

# Procedure named "filter" filters list elements by using a
# condition λ (lambda) expression
proc filter {l condition} {
  return [lmap el $l {
    if {![apply $condition $el]} continue
    set el
  }]
}

# Here the fun using lambda expressions begins. The following is the main program.

# Set λ expressions
set λPoliceEven {_ {expr [lindex $_ 0] % 2 == 0}}
set λNoEquals {_ {expr [llength [lsort -unique $_]] == [llength $_]}}
set λSumIs12 {_ {expr [join $_ +] == 12}}

# Create all combinations and filter acceptable ones
set numbersOk [filter [filter [filter [crossProduct [... 7 3]] ${λPoliceEven}] ${λSumIs12}] ${λNoEquals}]
puts [join $numbersOk \n]
puts "[llength $numbersOk] valid combinations found."
