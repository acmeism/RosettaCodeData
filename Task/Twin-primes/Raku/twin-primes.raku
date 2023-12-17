use Lingua::EN::Numbers;

use Math::Primesieve;

my $p = Math::Primesieve.new;

printf "Twin prime pairs less than %17s: %s\n", comma(10**$_), comma $p.count(10**$_, :twins) for 1 .. 12;
say (now - INIT now).round(.01) ~ ' seconds';
