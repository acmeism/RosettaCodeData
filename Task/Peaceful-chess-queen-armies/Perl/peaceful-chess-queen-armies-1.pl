use strict;
use warnings;

my $m = shift // 4;
my $n = shift // 5;
my %seen;
my $gaps = join '|', qr/-*/, map qr/.{$_}(?:-.{$_})*/s, $n-1, $n, $n+1;
my $attack = qr/(\w)(?:$gaps)(?!\1)\w/;

place( scalar ('-' x $n . "\n") x $n );
print "No solution to $m $n\n";

sub place
  {
  local $_ = shift;
  $seen{$_}++ || /$attack/ and return; # previously or attack
  (my $have = tr/WB//) < $m * 2 or exit !print "Solution to $m $n\n\n$_";
  place( s/-\G/ qw(W B)[$have % 2] /er ) while /-/g; # place next queen
  }
