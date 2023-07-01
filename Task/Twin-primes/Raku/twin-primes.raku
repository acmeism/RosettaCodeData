use Lingua::EN::Numbers;

use Math::Primesieve;

my $p = Math::Primesieve.new;

printf "Twin prime pairs less than %14s: %s\n", comma(10**$_), comma $p.count(10**$_, :twins) for 1 .. 10;
