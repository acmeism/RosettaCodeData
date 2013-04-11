open(FOO, '<', 'foobar.txt') or die $!;
while (my $line = <FOO>) {
    chomp($line);
    process($line);
}
close(FOO);
