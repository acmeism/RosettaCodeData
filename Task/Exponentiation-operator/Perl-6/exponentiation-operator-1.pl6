subset Natural of Int where { $^n >= 0 }

multi pow (0,     0)            { fail '0**0 is undefined' }
multi pow ($base, Natural $exp) { [*] $base xx $exp }
multi pow ($base, Int $exp)     { 1 / pow $base, -$exp }

sub infix:<***> ($a, $b) { pow $a, $b }
