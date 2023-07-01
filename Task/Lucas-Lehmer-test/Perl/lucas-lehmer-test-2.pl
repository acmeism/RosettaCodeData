use ntheory qw/:all/;
$|=1; # flush output on every print
my $n = 0;
for (1..47) {
  1 while !is_mersenne_prime(++$n);
  print "M$n ";
}
print "\n";
