sub rab (Int $n, Int $b = 1) {
    my $m = $n;
    $m +|= ($n +> $_) for ^ $b+1;
    $m
}

sub lab (Int $n, Int $b = 1) {
    my $m = $n;
    $m +|= ($n +< $_) for ^ $b+1;
    $m
}

say "Powers of 2 ≤ 8, 0 - Right-adjacent-bits: 2";
.&rab(2).base(2).fmt('%04s').say for <8 4 2 1 0>;

# Test with a few integers.
for 8,4, 18455760086304825618,5, 5444684034376312377319904082902529876242,15 -> $integer, $bits {

    say "\nInteger: $integer - Right-adjacent-bits: up to $bits";

    .say for ^$bits .map: -> $b { $integer.&rab($b).base: 2 };

    say "\nInteger: $integer - Left-adjacent-bits: up to $bits";

    .say for ^$bits .map: -> $b { $integer.&lab($b).fmt("%{0~$bits+$integer.msb}b") };

}
