use ntheory "forcomb";
my @S=("a","b","c");
for $k (0..@S) {
  # Iterate over each $#S+1,$k combination.
  forcomb { print "[@S[@_]]  " } @S,$k;
}
print "\n";
