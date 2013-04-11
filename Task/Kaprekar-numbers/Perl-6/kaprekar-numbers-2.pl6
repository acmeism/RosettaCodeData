sub kaprekar( Int $n, Int :$base = 10 ) {
    my $hi = $n ** 2;
    my $lo = 0;
    loop (my $s = 1; $hi; $s *= $base) {
        $lo += ($hi % $base) * $s;
        $hi div= $base;
        return $hi,$lo if $lo + $hi == $n and $lo;
    }
    ();
}

print " $_" if .&kaprekar for ^10_000;

say "\n\nBase 10 Kaprekar numbers < :10<1_000_000> = ", [+] (1 if kaprekar $_ for ^1000000);

say "\nBase 17 Kaprekar numbers < :17<1_000_000>";

my &k17 = &kaprekar.assuming(:base(17));

for ^:17<1000000> -> $n {
    my ($h,$l) = k17 $n;
    next unless $l;
    my $n17 = $n.base(17);
    my $s17 = ($n * $n).base(17);
    my $h17 = $h.base(17);
    say "$n $n17 $s17 ($h17 + $s17.substr(* - $h17.chars))";
}
