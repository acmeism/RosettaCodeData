proto pow (Real, Int --> Real) {*}
multi pow (0,     0)         { fail '0**0 is undefined' }
multi pow ($base, UInt $exp) { [*] $base xx $exp }
multi pow ($base, $exp)  { 1 / samewith $base, -$exp }

multi infix:<**> (Real $a, Int $b) { pow $a, $b }

# Testing

say pow .75, -5;
say .75 ** -5;
