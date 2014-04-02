sub sierpinski ($n) {
    my @down  = '*';
    my $space = ' ';
    for ^$n {
        @down = @down.map({"$space$_$space"}), @down.map({"$_ $_"});
        $space x= 2;
    }
    return @down;
}

.say for sierpinski 4;
