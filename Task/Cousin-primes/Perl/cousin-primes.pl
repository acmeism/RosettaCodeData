use warnings;
use feature 'say';
use ntheory 'is_prime';

my($limit, @cp) = 1000;
is_prime($_) and is_prime($_+4) and push @cp, "$_/@{[$_+4]}" for 2..$limit;
say @cp . " cousin prime pairs < $limit:\n" . (sprintf "@{['%8s' x @cp]}", @cp) =~ s/(.{56})/$1\n/gr;
