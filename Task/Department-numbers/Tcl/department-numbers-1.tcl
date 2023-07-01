# Procedure named ".." returns list of integers from 1 to max.
proc .. max {
  for {set i 1} {$i <= $max} {incr i} {
    lappend l $i
  }
  return $l
}

# Procedure named "anyEqual" returns true if any elements are equal,
# false otherwise.
proc anyEqual l {
  if {[llength [lsort -unique $l]] != [llength $l]} {
    return 1
  }
  return 0
}

# Procedure named "odd" tells whether a value is odd or not.
proc odd n {
  expr $n %2 != 0
}


# Procedure named "sum" sums its parameters.
proc sum args {
  expr [join $args +]
}


# Create lists of candidate numbers using proc ".."
set sanitation [.. 7]
set fire $sanitation
# Filter even numbers for police stations (remove odd ones).
set police [lmap e $sanitation {
  if [odd $e] continue
  set e
}]


# Try all combinations and display acceptable ones.
set valid 0
foreach p $police {
  foreach s $sanitation {
    foreach f $fire {
      # Check for equal elements in list.
      if [anyEqual [list $p $s $f]] continue
      # Check for sum of list elements.
      if {[sum $p $s $f] != 12} continue
      puts "$p $s $f"
      incr valid
    }
  }
}
puts "$valid valid combinations found."
