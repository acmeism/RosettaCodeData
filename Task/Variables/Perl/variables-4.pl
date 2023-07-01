$fruit="apple";    # this will be global by default

sub dofruit {
  print "My global fruit was $fruit,";    # use the global variable
  my $fruit="banana";                      # declare a new local variable
  print "and the local fruit is $fruit.\n";
}

dofruit;
print "The global fruit is still $fruit";
