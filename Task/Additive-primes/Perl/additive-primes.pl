use strict;
use warnings;
use ntheory 'is_prime';
use List::Util <sum max>;

sub pp {
    my $format = ('%' . (my $cw = 1+length max @_) . 'd') x @_;
    my $width  = ".{@{[$cw * int 60/$cw]}}";
    (sprintf($format, @_)) =~ s/($width)/$1\n/gr;
}

my($limit, @ap) = 500;
is_prime($_) and is_prime(sum(split '',$_)) and push @ap, $_ for 1..$limit;

print @ap . " additive primes < $limit:\n" . pp(@ap);
