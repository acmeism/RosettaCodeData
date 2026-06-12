# 20240927 Perl programming solution

use strict;
use warnings;

use constant I
   => [ qw( zero one two three four five six seven eight nine ten eleven twelve
            thirteen fourteen fifteen sixteen seventeen eighteen nineteen ) ];
use constant X
   => [ qw( 0 X twenty thirty forty fifty sixty seventy eighty ninety ) ];
use constant C => [map { I->[$_] . ' hundred' } 0..19];
use constant M => [
   map { $_ . ' thousand' } (0),
   map { $_ . 'illion' } ('m', 'b', 'tr', 'quadr', 'quint', 'sext', 'sept', 'oct', 'non',
   map { ('', 'un', 'duo', 'tre', 'quattuor', 'quin', 'sex', 'septen', 'octo', 'novem') }
   qw(dec vigint trigint quadragint quinquagint sexagint septuagint octogint nonagint))
];

sub int_name {
   my ($num) = @_;
   return "negative " . int_name(-$num) if $num < 0;
   return I->[0] if $num == 0;

   my ($m, @parts) = 0;
   while ($num > 0) {
      my $chunk = $num % 1000;
      my $hundreds = int($chunk / 100);
      my $tens = int(($chunk % 100) / 10);
      my $ones = $chunk % 10;

      if ($hundreds || $tens || $ones) {
         my @chunk_parts;
         push @chunk_parts, C->[$hundreds] if $hundreds;
         if ($tens == 1) {
            push @chunk_parts, I->[$ones + 10];
         } else {
            push @chunk_parts, X->[$tens] if $tens;
            push @chunk_parts, I->[$ones] if $ones;
         }
         push @chunk_parts, M->[$m] if $m;
         unshift @parts, join " ", @chunk_parts;
      }

      $num = int($num / 1000);
      $m++;
   }
   return join ", ", @parts;
}

my ($i, $c, $limit, $prev, @nums, @lastDigs) = (0, 0, 1000, int_name(0));

while ($limit <= 1e4) {
   my $next = int_name($i + 1);
   if (substr($prev, -1) eq substr($next, 0, 1)) {
      if ($c < 50) { push @nums, $i }
      $lastDigs[$i % 10]++;
      $c++;

      if ($c == 50) {
         print "First 50 numbers:\n";
         for (my $j = 0; $j < @nums; $j += 10) {
             printf "%4s", $_ for @nums[$j .. $j + 9];
             print "\n";
         }
         print "\n";
      } elsif ($c == $limit) {
         print "The $c-th number is $i.\n";
         print "Breakdown by last digit of first $c-th numbers\n";
         print "N Freq\n";
         my $max = (sort { $b <=> $a } @lastDigs)[0];
         for my $d (0..9) {
            printf "%d %4s %s\n", $d, $lastDigs[$d], '█' x int($lastDigs[$d] / $max * 72);
         }
         print "\n";
         $limit *= 10;
      }
   }
   $prev = $next;
   $i++;
}
