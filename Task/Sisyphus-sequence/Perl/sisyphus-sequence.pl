use strict;
use warnings;
use feature 'say';

use ntheory 'next_prime';
use List::Util <any max>;
use integer;

sub comma { reverse ((reverse shift) =~ s/.{3}\K/,/gr) =~ s/^,//r }
sub table { my $t = 10 * (my $c = 1 + length max @_); ( sprintf( ('%'.$c.'d')x@_, @_) ) =~ s/.{1,$t}\K/\n/gr }

my ($exp1, $exp2, $limit1, $limit2) = (3, 8, 100, 250);
my ($n, $s0, $s1, $p, @S1, %S, %S2) = (1, 1, 0, 1, 1);
my @Nth = map { 10**$_ } $exp1..$exp2;

do {
    $n++;
    $s1 = (0 == $s0%2) ? $s0/2 : $s0 + ($p = next_prime($p));
    push @S1, $s1 if  $n <= $limit1;
    $S2{$s1}++    if $s1 <= $limit2;
    ($S{$n}{'value'} = $s1 and $S{$n}{'prime'} = $p) if any { $_ == $n } @Nth;
    $s0 = $s1;
} until $n == $Nth[-1];

say 'The first 100 members of the Sisyphus sequence are:';
say table @S1;

printf "%12sth member is: %13s with prime: %11s\n", comma($_), comma($S{$_}{value}), comma($S{$_}{prime}) for @Nth;

printf "\nNumbers under $limit2 that do not occur in the first %s terms:\n", comma $Nth[-1];
say join ' ', grep { ! defined $S2{$_} } 1..$limit2;

my $max = max values %S2;
printf "\nNumbers under $limit2 occur the most ($max times) in the first %s terms:\n", comma $Nth[-1];
say join ' ', sort { $a <=> $b } grep { $S2{$_} == $max } keys %S2;
