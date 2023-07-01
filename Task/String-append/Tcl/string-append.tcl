set s "he"
set s "${s}llo wo";   # The braces distinguish varname from text to concatenate
append s "rld"
puts $s
