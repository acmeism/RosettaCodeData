set f [open abbreviations_automatic_weekdays.txt]
set lines [split [read -nonewline $f] \n]
close $f

foreach days $lines {
  if {[string length $days] == 0} continue
  if {[llength $days] != 7} {
    throw ERROR {not 7 days in a line}
  }
  if {[llength [lsort -unique $days]] != 7} {
    throw ERROR {not all 7 days in a line are distinct}
  }
  for {set i 0} {1} {incr i} {
    if {[llength [lsort -unique [lmap x $days {string range $x 0 $i}]]] == 7} break
  }
  incr i
  puts "$i $days"
}
