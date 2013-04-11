for ($_ = 0; $_ <= 9; $_++) {
  print "Outer";
  print "$_\n";
  # The inner loop will not nest properly unless
  # it is preceded by a my statement
  my $_;    # This is required to nest the inner loop
  for ($_ = 0; $_ <= 9; $_++) {
    print "Inner";
    print "$_\n";
  }
  # Alternatively we can use a local keyword in the
  # inner loop declaration instead of a my statement
  for (local $_ = 0; $_ <= 9; $_++) {
    print "Alternative";
    print "$_\n";
  }
}
