sub kigits($n) {
    my int $i = $n;
    my int $b = 1000;
    gather while $i {
        take $i % $b;
        $i = $i div $b;
    }
}

for (1..*) -> $d {
    my @t = 0..9 X** $d;
    my @table = @t X+ @t X+ @t;
    sub is-narcissistic(\n) { n == [+] @table[kigits(n)] };
    state $l = 2;
    FIRST say "1\t0";
    say $l++, "\t", $_ if .&is-narcissistic for 10**($d-1) ..^ 10**$d;
    last if $l > 25
};
