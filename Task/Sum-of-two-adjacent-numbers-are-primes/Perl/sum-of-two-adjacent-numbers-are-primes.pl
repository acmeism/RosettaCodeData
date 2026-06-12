use strict;
use warnings;
use ntheory 'is_prime';

my($n,$c);
while () { is_prime(1 + 2*++$n) and printf "%2d + %2d = %2d\n", $n, $n+1, 1+2*$n and ++$c == 20 and last }
