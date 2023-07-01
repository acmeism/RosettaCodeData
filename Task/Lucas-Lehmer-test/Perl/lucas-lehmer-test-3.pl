use ntheory qw/:all/;
use bigint try=>"GMP,Pari";
forprimes {
  my $p = $_;
  my $mp1 = 2**$p;
  print "M$p\n" if $p == 2 || 0 == (lucas_sequence($mp1-1, 4, 1, $mp1))[0];
} 43_112_609;
