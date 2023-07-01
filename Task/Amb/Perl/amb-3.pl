use strict;
use warnings;

sub amb {
   if( @_ == 0 ) {
      no warnings 'exiting';
      next AMB;
   }
   my $code = pop;
   my @words = @_;
   my @index = (0) x @words;
   AMB: while( 1 ) {
      my @w = map $words[$_][$index[$_]], 0 .. $#_;
      return $code->( @w );
   } continue {
      my $i = 0;
      while( ++$index[$i] == @{$words[$i]} ) {
         $index[$i] = 0;
         return if ++$i == @index;
      }
   }
}

my @w1 = qw(the that a);
my @w2 = qw(frog elephant thing);
my @w3 = qw(walked treaded grows);
my @w4 = qw(slowly quickly);

sub joined {
   my ($join_a, $join_b) = @_;
   substr($join_a, -1) eq substr($join_b, 0, 1);
}

amb( \(@w1, @w2, @w3, @w4), sub {
   my ($w1, $w2, $w3, $w4) = @_;
   amb() unless joined($w1, $w2);
   amb() unless joined($w2, $w3);
   amb() unless joined($w3, $w4);
   print "$w1 $w2 $w3 $w4\n";
});
