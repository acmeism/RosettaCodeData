use strict;
use warnings;
use feature 'say';
use List::Util 'sum';
use ntheory <is_prime todigitstring>;

sub test_digits { 0 != is_prime sum split '', todigitstring(shift, shift) }

my @p;
test_digits($_,2) and test_digits($_,3) and push @p, $_ for 1..199;
say my $result = @p . " matching numbers:\n" .  (sprintf "@{['%4d' x @p]}", @p) =~ s/(.{40})/$1\n/gr;
