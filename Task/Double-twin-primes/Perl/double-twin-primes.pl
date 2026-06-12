use v5.36;
use ntheory 'is_prime';

sub dt ($p) { map { $p + $_ } <0 2 6 8> }
for my $n (1..1000) { say "@{[dt $n]}" if 4 == +(grep { is_prime $_ } dt $n) }
