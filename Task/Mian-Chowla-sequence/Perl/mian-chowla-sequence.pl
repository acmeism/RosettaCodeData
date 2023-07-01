use strict;
use warnings;
use feature 'say';

sub generate_mc {
    my($max)  = @_;
    my $index = 0;
    my $test  = 1;
    my %sums  = (2 => 1);
    my @mc    = 1;
    while ($test++) {
        my %these = %sums;
        map { next if ++$these{$_ + $test} > 1 } @mc[0..$index], $test;
        %sums = %these;
        $index++;
        return @mc if (push @mc, $test) > $max-1;
    }
}

my @mian_chowla = generate_mc(100);
say "First 30 terms in the Mian–Chowla sequence:\n", join(' ', @mian_chowla[ 0..29]),
    "\nTerms 91 through 100:\n",                     join(' ', @mian_chowla[90..99]);
