for (1..2) {
  print "outer $_:\n";
  local $_;
  for (1..3) {
    print " inner $_,";
  }
  print " fini\n";
}
