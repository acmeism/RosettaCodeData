my $f = open 'test.txt';
while my $line = $f.get {
    say $line;
}
