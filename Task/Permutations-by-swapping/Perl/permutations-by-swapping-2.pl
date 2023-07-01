#!perl
use strict;
use warnings;

sub perms {
   my ($xx) = (shift);
   my @perms = ([+1]);
   for my $x ( 1 .. $xx ) {
      my $sign = -1;
      @perms = map {
         my ($s, @p) = @$_;
         map [$sign *= -1, @p[0..$_-1], $x, @p[$_..$#p]],
            $s < 0 ? 0 .. @p : reverse 0 .. @p;
      } @perms;
   }
   @perms;
}

my $n = shift() || 4;

for( perms($n) ) {
   my $s = shift @$_;
   $s = '+1' if $s > 0;
   print "[", join(", ", @$_), "] => $s\n";
}
