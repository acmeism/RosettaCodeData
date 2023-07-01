BEGIN {
  print "Goodbye, World!"| "cat 1>&2"
}
