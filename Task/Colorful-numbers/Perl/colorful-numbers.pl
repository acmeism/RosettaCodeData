use strict;
use warnings;
use feature 'say';
use enum qw(False True);
use List::Util <max uniqint product>;
use Algorithm::Combinatorics qw(combinations permutations);

sub table { my $t = shift() * (my $c = 1 + length max @_); ( sprintf( ('%'.$c.'d')x@_, @_) ) =~ s/.{1,$t}\K/\n/gr }

sub is_colorful {
    my($n) = @_;
    return True if 0 <= $n and $n <= 9;
    return False if $n =~ /0|1/ or $n < 0;
    my @digits = split '', $n;
    return False unless @digits == uniqint @digits;
    my @p;
    for my $w (0 .. @digits) {
        push @p, map { product @digits[$_ .. $_+$w] } 0 .. @digits-$w-1;
        return False unless @p == uniqint @p
    }
    True
}

say "Colorful numbers less than 100:\n" . table 10, grep { is_colorful $_ } 0..100;

my $largest = 98765432;
1 while not is_colorful --$largest;
say "Largest magnitude colorful number: $largest\n";

my $total= 10;
map { is_colorful(join '', @$_) and $total++ } map { permutations $_ } combinations [2..9], $_ for 2..8;
say "Total colorful numbers: $total";
