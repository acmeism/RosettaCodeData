multi sub circles (@A, @B where ([and] @A Z== @B), 0.0) { 'Degenerate point' }
multi sub circles (@A, @B where ([and] @A Z== @B), $)   { 'Infinitely many share a point' }
multi sub circles (@A, @B, $radius) {
    my @middle = (@A Z+ @B) X/ 2;
    my @diff = @A Z- @B;
    my $q = sqrt [+] @diff X** 2;
    return 'Too far apart' if $q > $radius * 2;

    my @orth = -@diff[0], @diff[1] X* sqrt($radius ** 2 - ($q / 2) ** 2) / $q;
    return (@middle Z+ @orth), (@middle Z- @orth);
}

my @input =
    ([0.1234, 0.9876],  [0.8765, 0.2345],   2.0),
    ([0.0000, 2.0000],  [0.0000, 0.0000],   1.0),
    ([0.1234, 0.9876],  [0.1234, 0.9876],   2.0),
    ([0.1234, 0.9876],  [0.8765, 0.2345],   0.5),
    ([0.1234, 0.9876],  [0.1234, 0.9876],   0.0),
    ;

for @input {
    say .list.raku, ': ', circles(|$_).join(' and ');
}
