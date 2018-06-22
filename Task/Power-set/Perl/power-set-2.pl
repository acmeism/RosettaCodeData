use ntheory "forcomb";
my @S = qw/a b c/;
forcomb { print "[@S[@_]]  " } scalar(@S);
print "\n";
