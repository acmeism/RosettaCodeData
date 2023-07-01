open(my $fh, '<', 'foobar.txt')
    || die "Could not open file: $!";
while (my $line = <$fh>)
{
    chomp $line;
    process($line);
}
close $fh;
