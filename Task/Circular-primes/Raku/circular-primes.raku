sub isCircular(\n) {
   return False unless n.is-prime;
   my @circular = n.comb;
   return False if @circular.min < @circular[0];
   for 1 ..^ @circular -> $i {
      return False unless .is-prime and $_ >= n given @circular.rotate($i).join;
   }
   True
}

say "The first 19 circular primes are:";
say ((2..*).hyper.grep: { isCircular $_ })[^19];

say "\nThe next 4 circular primes, in repunit format, are:";
loop ( my $i = 7, my $count = 0; $count < 4; $i++ ) {
   ++$count, say "R($i)" if (1 x $i).is-prime
}

use ntheory:from<Perl5> qw[is_prime];

say "\nRepunit testing:";

(5003, 9887, 15073, 25031, 35317, 49081).map: {
    my $now = now;
    say "R($_): Prime? ", ?is_prime("{1 x $_}"), "  {(now - $now).fmt: '%.2f'}"
}
