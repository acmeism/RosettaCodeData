use ntheory qw/factor forprimes/;
use bigint;

forprimes {
  my $p = 2 ** $_ - 1;
  print "2**$_-1: ", join(" ", factor($p)), "\n";
} 100, 150;
