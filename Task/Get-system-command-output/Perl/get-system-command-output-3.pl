use autodie;
my $enc = ':encoding(UTF-8)';
my $child_pid = open(my $pipe, "-|$enc", 'ls');
while (<$pipe>) {
  # Print all files whose names are all lowercase
    print if m/[^A-Z]+/;
}
