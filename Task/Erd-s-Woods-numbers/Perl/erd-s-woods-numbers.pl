# 20240915 Perl programming solution

use strict;
use warnings;
use List::Util qw(min);
use Math::BigInt;

sub mod_inverse { # rosettacode.org/wiki/Modular_inverse#Perl
   my ( $a, $n ) = @_;
   my ( $t, $nt, $r, $nr ) = ( 0, 1, $n, $a%$n );
   while ($nr != 0) {
      my $quot = int($r / $nr);
      ($nt, $t) = ($t - $quot * $nt, $nt);
      ($nr, $r) = ($r - $quot * $nr, $nr);
   }
   return if $r > 1;             # No inverse if gcd is not 1
   return $t < 0 ? $t += $n : $t # Make sure t is positive
}

sub erdos_woods {
   my ($n) = @_;
   my ($k, $P, @primes) = (2, Math::BigInt->new(1));

   while ($k < $n) {
      push @primes, $k if $P % $k;
      $P *= ($k++)**2;
   }

   my @divs = map {
      my $dividend = $_;
      oct("0b" . reverse( join('', map { $dividend % $_ ? 0 : 1 } @primes)) )
   } (0 .. $n - 1);

   my @partitions = ([0, 0, 2**(my $np = scalar @primes) - 1],);
   foreach my $i
      (sort {($divs[$b]|$divs[$n-$b])<=>($divs[$a]|$divs[$n-$a])} (1..$n-1)) {
      my ($factors, $other_factors, @new_partitions) = @divs[$i, $n-$i];

      foreach my $p (@partitions) {
         my ($set_a, $set_b, $r_primes) = @$p;

         if (($factors & $set_a) || ($other_factors & $set_b)) {
            push @new_partitions, $p and next
         }

         for my $ix (0 .. $np-1) {
            my $w = 1 << $ix;
            push @new_partitions, [$set_a ^ $w, $set_b, $r_primes ^ $w]
               if ($factors & $r_primes) & $w;
            push @new_partitions, [$set_a, $set_b ^ $w, $r_primes ^ $w]
               if ($other_factors & $r_primes) & $w;
         }
      }
      @partitions = @new_partitions;
   }

   my $result = Math::BigInt->new("inf");
   foreach my $partition (@partitions) {
      my ($px, $py, $dummy) = @$partition;
      my ($x, $y) = (Math::BigInt->new(1), Math::BigInt->new(1));
      foreach my $p (@primes) {
         $x *= $p if $px % 2;
         $y *= $p if $py % 2;
         $px = int($px / 2);
         $py = int($py / 2);
      }
      $result = min($result, ($n * mod_inverse($x, $y)) % $y * $x - $n);
   }
   return $result
}

my ($K, $COUNT, $N) = (3, 0, 20);
print "The first $N Erdős–Woods numbers and their minimum interval start values are:\n";
while ($COUNT < $N) {
   my $a = Math::BigInt->new(erdos_woods($K));
   if ( $a ne 'inf') { printf "%3.d -> $a\n", $K and $COUNT++ }
   $K++;
}
