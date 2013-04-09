my $a = 5;
#...input or change $a here
$a == 42 or die "Error message\n";
# or, alternatively:
die "Error message\n" unless $a == 42;
# or:
die "Error message\n" if not $a == 42;
# or just:
die "Error message\n" if $a != 42;
