use strict;
use warnings;

my %pps;
my $maxDigits = 9;

sub totient {
   my $tot = my $n = shift;
   my $i   = 2;
   while ($i*$i <= $n) {
      unless ($n % $i) {
         until($n % $i) { $n = int($n/$i) }
         $tot -= int($tot/$i)
      }
      if ($i == 2) { $i = 1 }
      $i += 2;
   }
   if ($n > 1) { $tot -= int($tot/$n) }
   return $tot
}

sub getPerfectPowers {
   for my $i (2..int(sqrt(my $upper = 10**( shift )))) {
      my $p = $i;
      while (($p *= $i) < $upper) { $pps{$p}++ }
   }
}

sub getAchilles {
   my ($lower, $upper) = map { 10** $_ } @_ ;
   my %achilles = ();
   my $count = 0;
   for my $b (1..int($upper**(1/3))) {
      my ($b3,$p) = $b * $b * $b;
      for my $a (1..int(sqrt($upper))) {
         last if (($p = $b3 * $a * $a) >= $upper);
         $achilles{$p}++ if ($p >= $lower and !$pps{$p})
      }
   }
   return keys %achilles
}

getPerfectPowers $maxDigits;

my @achilles = sort { $a <=> $b } getAchilles(1,5);
my %achillesSet;
@achillesSet{ @achilles } = undef;

print "First 50 Achilles numbers:\n";
for (0..49) { printf "%5d".($_%10 == 9 ? "\n" : " "), $achilles[$_] }

my %strongAchilles;
my $count = my $n = 0;
for (my $count = my $n = 0; $count < 30; $n++) {
   if ( exists($achillesSet{ totient( $achilles[$n] ) })) {
      $strongAchilles{ $achilles[$n] }++;
      $count++
   }
}

my @strongAchilles30 = (sort { $a <=> $b } keys %strongAchilles)[0..29];

print "\nFirst 30 strong Achilles numbers:\n";
for (0..29) { printf "%5d".($_%10 == 9 ? "\n" : " "), $strongAchilles30[$_] }

print "\nNumber of Achilles numbers with:\n";
for my $d (2..$maxDigits) {
   printf "%2d digits: %d\n", $d, scalar getAchilles($d-1, $d)
}
