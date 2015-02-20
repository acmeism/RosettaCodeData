sub kigits($n) {
    my int $i = $n;
    my int $b = 1000;
    gather while $i {
        take $i % $b;
        $i = $i div $b;
    }
}

constant narcissistic = 0, (1..*).map: -> $d {
    my @t = 0..9 X** $d;
    my @table = @t X+ @t X+ @t;
    sub is-narcissistic(\n) { n == [+] @table[kigits(n)] }
    gather take $_ if is-narcissistic($_) for 10**($d-1) ..^ 10**$d;
}

for narcissistic {
    say ++state $n, "\t", $_;
    last if $n == 25;
}
