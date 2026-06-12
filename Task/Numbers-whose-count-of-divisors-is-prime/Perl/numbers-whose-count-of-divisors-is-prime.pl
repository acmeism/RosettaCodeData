use strict;
use warnings;
use ntheory <is_prime divisors>;

push @matches, $_**2 for grep { is_prime divisors $_**2 } 1..int sqrt 1e5;
print @matches . " matching:\n" . (sprintf "@{['%6d' x @matches]}", @matches) =~ s/(.{72})/$1\n/gr;
