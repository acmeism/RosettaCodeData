my @haystack = qw(Zig Zag Wally Ronald Bush Krusty Charlie Bush Bozo);

my %haystack_indices;
@haystack_indices{ @haystack } = (0 .. $#haystack); # Caution: this finds the largest index, not the smallest

foreach my $needle (qw(Washington Bush)) {
  my $index = $haystack_indices{$needle};
  if (defined $index) {
    print "$index $needle\n";
  } else {
    print "$needle is not in haystack\n";
  }
}
