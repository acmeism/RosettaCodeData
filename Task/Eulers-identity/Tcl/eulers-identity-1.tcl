# Set up complex sandbox (since we're doing a star import)
namespace eval complex_ns {
    package require math::complexnumbers
    namespace import ::math::complexnumbers::*

    set pi [expr {acos(-1)}]

    set r [+ [exp [complex 0 $pi]] [complex 1 0]]
    puts "e**(pi*i) = [real $r]+[imag $r]i"
}
