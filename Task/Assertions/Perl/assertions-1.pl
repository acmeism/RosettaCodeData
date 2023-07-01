print "Give me a number: ";
chomp(my $a = <>);

$a == 42 or die "Error message\n";

# Alternatives
die "Error message\n" unless $a == 42;
die "Error message\n" if not $a == 42;
die "Error message\n" if $a != 42;
