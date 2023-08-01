use strict;
use warnings;
use feature <say signatures>;
no warnings 'experimental::signatures';

use List::Util 'uniq';
use ntheory <primes vecprod factor>;

sub comma      { reverse ((reverse shift) =~ s/.{3}\K/,/gr) =~ s/^,//r }
sub table (@V) { ( sprintf( ('%3d')x@V, @V) ) =~ s/.{1,30}\K/\n/gr }

sub radical ($n) { vecprod uniq factor $n }

my $limit = 1e6;

my $primes = primes(1,$limit);

my %rad;
$rad{1} = 1;
$rad{ uniq factor $_ }++ for 2..$limit;

my $powers;
my $upto = int sqrt $limit;
for my $p ( grep { $_< $upto} @$primes ) {
   for (2..$upto) { ($p ** $_) < $limit ? ++$powers : last }
}

say 'First fifty radicals:';
say table map { radical $_ } 1..50;
printf "Radical for %7s => %7s\n", comma($_), comma radical($_) for 99999, 499999, 999999;
printf "\nRadical factor count breakdown, 1 through %s:\n", comma $limit;
say "$_ => " . comma $rad{$_} for sort keys %rad;
say <<~"END";

    Up to @{[comma $limit]}:
    Primes: @{[comma 0+@$primes]}
    Powers:    $powers
    Plus 1:      1
    Total:  @{[comma 1 + $powers + @$primes]}
    END
