use strict;
use warnings;
use List::Util 'max';
use ntheory 'is_prime';

sub pp {
    my $format = ('%' . (my $cw = 1+length max @_) . 'd') x @_;
    my $width  = ".{@{[$cw * int 60/$cw]}}";
    (sprintf($format, @_)) =~ s/($width)/$1\n/gr;
}

my($limit, @rp) = 500;
is_prime($_) and is_prime(reverse $_) and push @rp, $_ for 1..$limit;
print @rp . " reversible primes < $limit:\n" . pp(@rp);
