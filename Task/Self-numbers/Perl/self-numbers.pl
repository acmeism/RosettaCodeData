use strict;
use warnings;
use feature 'say';
use List::Util qw(max sum);

my ($i, $pow, $digits, $offset, $lastSelf, @selfs)
 = ( 1,   10,       1,       9,         0,       );

my $final = 50;

while () {
   my $isSelf = 1;
   my $sum = my $start = sum split //, max(($i-$offset), 0);
   for ( my $j = $start; $j < $i; $j++ ) {
      if ($j+$sum == $i) { $isSelf = 0 ; last }
      ($j+1)%10 != 0 ? $sum++ : ( $sum = sum split '', ($j+1) );
   }

   if ($isSelf) {
      push @selfs, $lastSelf = $i;
      last if @selfs == $final;
   }

   next unless ++$i % $pow == 0;
   $pow *= 10;
   $offset = 9 * $digits++
}

say "The first 50 self numbers are:\n" . join ' ', @selfs;
