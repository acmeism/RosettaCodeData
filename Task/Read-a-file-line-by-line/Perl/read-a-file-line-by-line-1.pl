open(my $fh, '<', 'foobar.txt')
    || die "Could not open file: $!";
while (<$fh>)
{ # each line is stored in $_, with terminating newline
  # chomp, short for chomp($_), removes the terminating newline
    chomp;
    process($_);
}
close $fh;
