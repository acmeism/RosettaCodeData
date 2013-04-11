rename unknown __unknown
proc unknown {args} {
   if {3 == [llength $args]} {
      package require control
      return [control::do {*}$args]
   } else {
      return [__unknown {*}$args]
   }
}
#usage
% {set i 0; puts "hello world"; incr i} until {$i > 0}
hello world
