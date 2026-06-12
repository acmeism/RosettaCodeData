use strict;
use warnings;
use feature 'say';
use List::Util 'sum';

sub find_intersection {
   my($P1, $P2, $center, $radius) = @_;
   my @d = ($$P2[0] -     $$P1[0], $$P2[1] -     $$P1[1]);
   my @f = ($$P1[0] - $$center[0], $$P1[1] - $$center[1]);
   my $a = sum map { $_**2 } @d;
   my $b = 2 * ($f[0]*$d[0] + $f[1]*$d[1]);
   my $c = sum(map { $_**2 } @f) - $radius**2;
   my $D =  $b**2 - 4*$a*$c;

   return unless $D >= 0;
   my ($t1, $t2) = ( (-$b - sqrt $D) / (2*$a), (-$b + sqrt $D) / (2*$a) );
   return unless $t1 >= 0 and $t1 <= 1 or $t2 >= 0 and $t2  <= 1;

   my ($dx, $dy) = ($$P2[0] - $$P1[0], $$P2[1] - $$P1[1]);
   return ([$dx*$t1 + $$P1[0], $dy*$t1 + $$P1[1]],
           [$dx*$t2 + $$P1[0], $dy*$t2 + $$P1[1]])
}

my @data = (
   [ [-10, 11], [ 10, -9], [3, -5], 3 ],
   [ [-10, 11], [-11, 12], [3, -5], 3 ],
   [ [  3, -2], [  7, -2], [3, -5], 3 ],
   [ [  3, -2], [  7, -2], [0,  0], 4 ],
   [ [  0, -3], [  0,  6], [0,  0], 4 ],
   [ [  6,  3], [ 10,  7], [4,  2], 5 ],
   [ [  7,  4], [ 11, 18], [4,  2], 5 ],
);

sub rnd { map { sprintf('%.2f', $_) =~ s/\.00//r } @_ }

for my $d (@data) {
   my @solution = find_intersection @$d[0] , @$d[1] , @$d[2], @$d[3];
   say 'For input: ' . join ', ', (map { '('. join(',', @$_) .')' } @$d[0,1,2]), @$d[3];
   say 'Solutions: ' . (@solution > 1 ? join ', ', map { '('. join(',', rnd @$_) .')' } @solution : 'None');
   say '';
}
