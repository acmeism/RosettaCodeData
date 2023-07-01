set str "abcdefgh"
set n 2
set m 3

puts [string range $str $n [expr {$n+$m-1}]]
puts [string range $str $n end]
puts [string range $str 0 end-1]
# Because Tcl does substrings with a pair of indices, it is easier to express
# the last two parts of the task as a chained pair of [string range] operations.
# A maximally efficient solution would calculate the indices in full first.
puts [string range [string range $str [string first "d" $str] end] [expr {$m-1}]]
puts [string range [string range $str [string first "de" $str] end] [expr {$m-1}]]

# From Tcl 8.5 onwards, these can be contracted somewhat.
puts [string range [string range $str [string first "d" $str] end] $m-1]
puts [string range [string range $str [string first "de" $str] end] $m-1]
