sub do-stuff ($line) {
    say $line;
}

my $n = +get;
for ^$n {
    my $line = get;
    do-stuff $line;
}
