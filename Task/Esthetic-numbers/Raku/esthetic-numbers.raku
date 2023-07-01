use Lingua::EN::Numbers;

sub esthetic($base = 10) {
    my @s = ^$base .map: -> \s {
        ((s - 1).base($base) if s > 0), ((s + 1).base($base) if s < $base - 1)
    }

    flat [ (1 .. $base - 1)».base($base) ],
    { [ flat .map: { $_ xx * Z~ flat @s[.comb.tail.parse-base($base)] } ] } … *
}

for 2 .. 16 -> $b {
    put "\n{(4 × $b).&ordinal-digit} through {(6 × $b).&ordinal-digit} esthetic numbers in base $b";
    put esthetic($b)[(4 × $b - 1) .. (6 × $b - 1)]».fmt('%3s').batch(16).join: "\n"
}

my @e10 = esthetic;
put "\nBase 10 esthetic numbers between 1,000 and 9,999:";
put @e10.&between(1000, 9999).batch(20).join: "\n";

put "\nBase 10 esthetic numbers between {1e8.Int.&comma} and {1.3e8.Int.&comma}:";
put @e10.&between(1e8.Int, 1.3e8.Int).batch(9).join: "\n";

sub between (@array, Int $lo, Int $hi) {
    my $top = @array.first: * > $hi, :k;
    @array[^$top].grep: * > $lo
}
