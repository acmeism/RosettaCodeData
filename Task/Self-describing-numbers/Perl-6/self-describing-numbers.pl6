my @values = <1210 2020 21200 3211000
42101000 521001000 6210001000 27 115508>;

for @values -> $test {
    say "$test is {$test.&sdn ?? '' !! 'NOT ' }a self describing number.";
}

sub sdn ($num) {
    my @digits;
    my $chars = $num.chars;
    @digits[$_]++ for $num.comb;
    return 0 if @digits.elems > $chars;
    @digits[$_] //= '0' for ^$chars;
    my $string =  join '', @digits;
    return 1 if $num eq $string;
}

say $_ if $_.&sdn for ^9999999;
