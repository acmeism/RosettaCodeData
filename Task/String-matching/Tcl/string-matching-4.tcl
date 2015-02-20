set matchLocations [regexp -indices -all -inline ***=$needle $haystack]
# Each match location is a pair, being the index into the string where the needle started
# to match and the index where the needle finished matching

set isContained [expr {[llength $matchLocations] > 0}]
set isPrefix [expr {[lindex $matchLocations 0 0] == 0}]
set isSuffix [expr {[lindex $matchLocations end 1] == [string length $haystack]-1}]
set firstMatchStart [lindex $matchLocations 0 0]
puts "Found \"$needle\" in \"$haystack\" at $firstMatchStart"
foreach location $matchLocations {
    puts "needle matched at index [lindex $location 0]"
}
