# make {+ - * /} etc available as commands, for easier expressions
namespace path ::tcl::mathop

# find epsilon with native floating point:
proc epsilon {} {
    set e 1.0
    while {1 + $e != 1} {
        set e   [/ $e 2]
    }
    return $e
}

# kahan sum with native floats:
proc kahansum {args} {
    set sum 0.0
    set c   0.0
    foreach i $args {
        set y   [- $i $c]
        set t   [+ $sum $y]
        set c   [- [- $t $sum] $y]
        set sum $t
    }
    return $sum
}

puts "Native floating point:"
puts "\tEpsilon is: [set e [epsilon]]"
puts "\tAssociative sum: [expr {1.0 + $e - $e}]"
puts "\tKahan sum: [kahansum 1.0 $e -$e]"
