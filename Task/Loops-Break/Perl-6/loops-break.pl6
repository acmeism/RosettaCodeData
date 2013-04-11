loop {
    say my $n = (0..19).pick;
    last if $n == 10;
    say (0..19).pick;
}
