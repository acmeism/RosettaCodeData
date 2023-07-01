if {[string equal $s ""]} {puts "is empty"}
if {[string length $s] == 0} {puts "is empty"}
if {[string compare $s ""] != 0} {puts "is non-empty"}
