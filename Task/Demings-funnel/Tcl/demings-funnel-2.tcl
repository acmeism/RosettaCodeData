package require math::constants
package require simulation::random

math::constants::constants degtorad

set rng(radius) [simulation::random::prng_Normal 0.0 1.0]
set rng(angle) [simulation::random::prng_Uniform 0.0 360.0]
set dxs [set dys {}]
for {set i 0} {$i < 500} {incr i} {
    set r [$rng(radius)]
    set theta [expr {[$rng(angle)] * $degtorad}]
    lappend dxs [expr {$r * cos($theta)}]
    lappend dys [expr {$r * sin($theta)}]
}

puts "USING RANDOM DATA"
experiment "Rule 1:" $dxs $dys {{z dz} {expr {0}}}
experiment "Rule 2:" $dxs $dys {{z dz} {expr {-$dz}}}
experiment "Rule 3:" $dxs $dys {{z dz} {expr {-($z+$dz)}}}
experiment "Rule 4:" $dxs $dys {{z dz} {expr {$z+$dz}}}
