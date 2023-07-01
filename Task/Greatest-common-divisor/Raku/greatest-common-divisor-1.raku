sub gcd (Int $a is copy, Int $b is copy) {
   $a & $b == 0 and fail;
   ($a, $b) = ($b, $a % $b) while $b;
   return abs $a;
}
