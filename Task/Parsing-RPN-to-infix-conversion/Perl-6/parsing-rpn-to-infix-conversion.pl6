my @tests = '3 4 2 * 1 5 - 2 3 ^ ^ / +',
            '1 2 + 3 4 + ^ 5 6 + ^';

say rpm-to-infix($_) for @tests;

sub p ($pair, $prec) {
    $pair.key < $prec ?? "( $pair.value() )" !! $pair.value
}
sub rpm-to-infix($string) {
    say "=================\n$string";
    my @stack;
    for $string.words {
        when /\d/ { @stack.push: 9 => $_ }
        my $y = @stack.pop;
        my $x = @stack.pop;
        when '^'       { @stack.push: 4 => ~(p($x,5), $_, p($y,4)) }
        when '*' | '/' { @stack.push: 3 => ~(p($x,3), $_, p($y,3)) }
        when '+' | '-' { @stack.push: 2 => ~(p($x,2), $_, p($y,2)) }
        # LEAVE { say @stack } # phaser not yet implemented in this context
    }
    say "-----------------";
    @stack».value;
}
