sub insert_after {
  my $node = $_[0];
  my $next = $node->{next};
  shift;
  while (defined $_[0]) {
    $node->{next} = $_[0];
    $node = $node->{next};
    shift;
  }
  $node->{next} = $next;
}
