use POSIX;

my ($num, $n_unparsed) = strtol('1a', 16);
$n_unparsed == 0 or die "invalid characters found";
print "$num\n"; # prints "26"
