use List::Util "sum";
for my $n (1..5000) {
  print "$n\n" if $n == sum( map { $_**$_ } split(//,$n) );
}
