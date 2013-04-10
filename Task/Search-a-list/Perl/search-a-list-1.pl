use List::Util qw(first);

my @haystack = qw(Zig Zag Wally Ronald Bush Krusty Charlie Bush Bozo);

foreach my $needle (qw(Washington Bush)) {
  my $index = first { $haystack[$_] eq $needle } (0 .. $#haystack); # note that "eq" was used because we are comparing strings
                                                                    # you would use "==" for numbers
  if (defined $index) {
    print "$index $needle\n";
  } else {
    print "$needle is not in haystack\n";
  }
}
