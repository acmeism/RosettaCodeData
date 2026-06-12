# 20240926 Perl programming solution

use strict;
use warnings;

sub factorial {
   my $n = shift;
   my ($i, $result) = (1, 1);
   for ( ; $i <= $n or return $result; $i++) { $result *= $i }
}

sub binomial {
   my ($n, $k) = @_;
   return factorial($n) / (factorial($k) * factorial($n - $k));
}

sub binomial_transform {
   my @seq = @_;
   my @result;

   for my $n (0 .. $#seq) {
      my $sum = 0;
      for my $k (0 .. $n) {
         my $binom = binomial($n, $k);
         my $term = $binom * $seq[$k];
         $sum += $term;
      }
      push @result, $sum;
   }
   return @result;
}

sub inverse_binomial_transform {
   my @seq = @_;
   my @result;

   for my $n (0 .. $#seq) {
      my $sum = 0;
      for my $k (0 .. $n) {
         my $binom = binomial($n, $k);
         my $term = ((-1) ** ($n - $k)) * $binom * $seq[$k];
         $sum += $term;
      }
      push @result, $sum;
   }
   return @result;
}

sub self_inverting_transform {
   my @seq = @_;
   my @result;

   for my $n (0 .. $#seq) {
      my $sum = 0;
      for my $k (0 .. $n) {
         my $sign = ($k % 2 == 0) ? 1 : -1;
         my $binom = binomial($n, $k);
         my $term = $sign * $binom * $seq[$k];
         $sum += $term;
      }
      push @result, $sum;
   }
   return @result;
}

my @sequences = (
   {
      name => 'Catalan number sequence',
      seq  => [1, 1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796, 58786, 208012, 742900, 2674440, 9694845, 35357670, 129644790, 477638700, 1767263190],
   },
   {
      name => 'Prime flip-flop sequence',
      seq  => [0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0],
   },
   {
      name => 'Fibonacci number sequence',
      seq  => [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181],
   },
   {
      name => 'Padovan number sequence',
      seq  => [1, 0, 0, 1, 0, 1, 1, 1, 2, 2, 3, 4, 5, 7, 9, 12, 16, 21, 28, 37],
   }
);

for my $test_case (@sequences) {
   my $name = $test_case->{name};
   my @seq  = @{$test_case->{seq}};

   print "$name:\n@seq[0 .. $#seq]\n";

   my @forward = binomial_transform(@seq);
   print "Forward binomial transform:\n@forward[0 .. $#forward]\n";

   my @inverse = inverse_binomial_transform(@seq);
   print "Inverse binomial transform:\n@inverse[0 .. $#inverse]\n";

   my @round_trip = inverse_binomial_transform(@forward);
   print "Round trip:\n@round_trip[0 .. $#round_trip]\n";

   my @self_inverting = self_inverting_transform(@seq);
   print "Self inverting:\n@self_inverting[0 .. $#self_inverting]\n";

   my @re_inverted = self_inverting_transform(@self_inverting);
   print "Re inverted:\n@re_inverted[0 .. $#re_inverted]\n\n";
}
