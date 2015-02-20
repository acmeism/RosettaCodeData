use ntheory qw/binomial/;
sub pascal {
  my $rows = shift;
  for my $n (0 .. $rows-1) {
    print join(" ", map { binomial($n,$_) } 0 .. $n), "\n";
  }
}
