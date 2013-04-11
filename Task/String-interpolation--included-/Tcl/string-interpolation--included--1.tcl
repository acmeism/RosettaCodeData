set size "little"
puts "Mary had a $size lamb."

proc RandomWord {args} {
   lindex $args [expr {int(rand()*[llength $args])}]
}
puts "Mary had a [RandomWord little big] lamb."
