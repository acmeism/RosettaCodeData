use strict;
use warnings;
use ntheory 'gcd';

printf "%7s %s\n", (gcd(@$_) == 1 ? 'Coprime' : ''), join ', ', @$_
     for [21,15], [17,23], [36,12], [18,29], [60,15], [21,22,25,31,143];
