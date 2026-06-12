package require Tcl 8.5
package require math::numtheory
namespace path ::tcl::mathop

puts [lmap x [math::numtheory::primesLowerThan 5000] {
    if {[+ {*}[split $x {}]] == 25} {set x} else continue
}]
