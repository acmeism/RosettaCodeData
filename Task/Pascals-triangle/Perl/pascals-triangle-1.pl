sub pascal
  my $rows = shift;
  my @next = (1);
  for my $n (1 .. $rows) {
    print "@next\n";
    @next = (1, (map $next[$_]+$next[$_+1], 0 .. $n-2), 1);
  }
