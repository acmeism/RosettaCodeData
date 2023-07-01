use ntheory qw/:all/;

my $n = 3;
print "    Iterate Lexicographic rank/unrank of $n objects\n";
for my $k (0 .. factorial($n)-1) {
  my @perm = numtoperm($n, $k);
  my $rank = permtonum(\@perm);
  die unless $rank == $k;
  printf "%2d --> [@perm] --> %2d\n", $k, $rank;
}
print "\n";

print "    Four 12-object random permutations using ranks\n";
print join(" ", numtoperm(12,urandomm(factorial(12)))), "\n"  for 1..4;
print "\n";
print "    Four 12-object random permutations using randperm\n";
print join(" ", randperm(12)),"\n"  for 1..4;
print "\n";
print "    Four 4-object random permutations of 100k objects using randperm\n";
print join(" ", randperm(100000,4)),"\n"  for 1..4;
