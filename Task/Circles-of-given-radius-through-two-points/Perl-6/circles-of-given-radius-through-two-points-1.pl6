sub circles(@A, @B where (not [and] @A Z== @B), $radius where * > 0) {
    my @middle = .5 X* (@A Z+ @B);
    my @diff = @A Z- @B;
    my @orth = -@diff[1], @diff[0] X/
    2 * tan asin 2*$radius R/ sqrt [+] @diff X**2;

    return (@middle Z+ @orth).item, (@middle Z- @orth).item;
}

my @input =
\([0.1234, 0.9876],  [0.8765, 0.2345],   2.0),
\([0.0000, 2.0000],  [0.0000, 0.0000],   1.0),
\([0.1234, 0.9876],  [0.1234, 0.9876],   2.0),
\([0.1234, 0.9876],  [0.8765, 0.2345],   0.5),
\([0.1234, 0.9876],  [0.1234, 0.9876],   0.0),
;

for @input -> $input {
    say $input.perl, ": ",
    try { say join " and ", circles(|$input) }
}
