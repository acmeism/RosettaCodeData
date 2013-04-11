multi gcd (0,      0)      { fail }
multi gcd (Int $a, 0)      { abs $a }
multi gcd (Int $a, Int $b) { gcd $b, $a % $b }
