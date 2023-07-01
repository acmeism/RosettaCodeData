use strict;
use warnings;
use feature 'say';
use ntheory qw(primes factor_exp lcm);

sub pisano_period_pp {
    my($a, $b, $n, $k) = (0, 1, $_[0]**$_[1]);
    while (++$k) {
        ($a, $b) = ($b, ($a+$b) % $n);
        return $k if $a == 0 and $b == 1;
    }
}

sub pisano_period {
    (lcm map { pisano_period_pp($$_[0],$$_[1]) } factor_exp($_[0])) or 1;
}

sub display { (sprintf "@{['%5d' x @_]}", @_) =~ s/(.{75})/$1\n/gr }

say "Pisano periods for squares of primes p <= 50:\n", display( map { pisano_period_pp($_, 2) } @{primes(1,  50)} ),
  "\nPisano periods for primes p <= 180:\n",           display( map { pisano_period_pp($_, 1) } @{primes(1, 180)} ),
"\n\nPisano periods for integers n from 1 to 180:\n",  display( map { pisano_period   ($_   ) }          1..180   );
