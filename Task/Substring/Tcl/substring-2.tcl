# Define the substring operation, efficiently
proc ::substring {string start length} {
    string range $string $start [expr {$start + $length - 1}]
}
# Plumb it into the language
set ops [namespace ensemble configure string -map]
dict set ops substr ::substring
namespace ensemble configure string -map $ops

# Now show off by repeating the challenge!
set str "abcdefgh"
set n 2
set m 3

puts [string substr $str $n $m]
puts [string range $str $n end]
puts [string range $str 0 end-1]
puts [string substr $str [string first "d" $str] $m]
puts [string substr $str [string first "de" $str] $m]
