my @values = <1210 2020 21200 3211000
42101000 521001000 6210001000 27 115508>;

for @values -> $test {
    say "$test is {sdn($test) ?? '' !! 'NOT ' }a self describing number.";
}

sub sdn($n) {
    my $s = $n.Str;
    my $chars = $s.chars;
    my @a = +«$s.comb;
    my @b;
    for @a -> $i {
        return False if $i >= $chars;
        ++@b[$i];
    }
    @b[$_] //= 0 for ^$chars;
    @a eqv @b;
}

.say if .&sdn for ^9999999;
