package require math::decimal
namespace path ::math::decimal

proc kahansum {args} {
    set sum [fromstr 0.0]
    set c   [fromstr 0.0]
    foreach i $args {
        set i [fromstr $i]
        set y   [- $i $c]
        set t   [+ $sum $y]
        set c   [- [- $t $sum] $y]
        set sum $t
    }
    return [tostr $sum]
}

proc asum {args} {
    set sum [fromstr 0.0]
    foreach a $args {
        set sum [+ $sum [fromstr $a]]
    }
    return [tostr $sum]
}

setVariable precision 6
set a 10000.0
set b 3.14159
set c 2.71828

foreach rounding {half_even half_up half_down down up floor ceiling} {
    setVariable rounding $rounding
    puts "Rounding mode: $rounding"
    puts "\tAssociative sum $a + $b + $c: [asum $a $b $c]"
    puts "\tKahan       sum $a + $b + $c: [kahansum $a $b $c]"
}
