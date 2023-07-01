use Prime::Factor;
use List::Divvy;
use Lingua::EN::Numbers;

sub radical ($_) { [×] unique .&prime-factors }

say "First fifty radicals:\n" ~
  (1..50).map({.&radical}).batch(10)».fmt("%2d").join: "\n";
say '';

printf "Radical for %7s => %7s\n", .&comma, comma .&radical
  for 99999, 499999, 999999;

my %rad = 1 => 1;
my $limit = 1e6.Int;

%rad.push: $_ for (2..$limit).race(:1000batch).map: {(unique .&prime-factors).elems => $_};

say "\nRadical factor count breakdown, 1 through {comma $limit}:";
say .key ~ " => {comma +.value}" for sort %rad;

my @primes = (2..$limit).grep: &is-prime;

my int $powers;
@primes.&upto($limit.sqrt.floor).map: -> $p {
   for (2..*) { ($p ** $_) < $limit ?? ++$powers !! last }
}

say qq:to/RADICAL/;

    Up to {comma $limit}:
    Primes: {comma +@primes}
    Powers:    $powers
    Plus 1:      1
    Total:  {comma 1 + $powers + @primes}
    RADICAL
