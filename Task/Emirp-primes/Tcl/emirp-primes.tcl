package require math::numtheory

# Import only to keep line lengths down
namespace import math::numtheory::isprime
proc emirp? {n} {
    set r [string reverse $n]
    expr {$n != $r && [isprime $n] && [isprime $r]}
}

# Generate the various emirps
for {set n 2;set emirps {}} {[llength $emirps] < 20} {incr n} {
    if {[emirp? $n]} {lappend emirps $n}
}
puts "first20: $emirps"

for {set n 7700;set emirps {}} {$n <= 8000} {incr n} {
    if {[emirp? $n]} {lappend emirps $n}
}
puts "7700-8000: $emirps"

for {set n 2;set ne 0} true {incr n} {
    if {[emirp? $n] && [incr ne] == 10000} break
}
puts "10,000: $n"
