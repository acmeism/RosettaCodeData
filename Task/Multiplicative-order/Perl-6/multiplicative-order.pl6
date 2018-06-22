my @primes := 2, |grep *.is-prime, (3,5,7...*);

sub factor($a is copy) {
    gather {
        for @primes -> $p {
            my $j = 0;
            while $a %% $p {
                $a div= $p;
                $j++;
            }
            take $p => $j if $j > 0;
            last if $a < $p * $p;
        }

        take $a => 1 if $a > 1;
    }
}

sub mo-prime($a, $p, $e) {
    my $m = $p ** $e;
    my $t = ($p - 1) * ($p ** ($e - 1)); #  = Phi($p**$e) where $p prime
    my @qs = 1;
    for factor($t) -> $f {
        @qs = flat @qs.map(-> $q { (0..$f.value).map(-> $j { $q * $f.key ** $j }) });
    }

    @qs.sort.first(-> $q { expmod( $a, $q, $m ) == 1});
}

sub mo($a, $m) {
    $a gcd $m == 1 || die "$a and $m are not relatively prime";
    [lcm] flat 1, factor($m).map(-> $r { mo-prime($a, $r.key, $r.value) });
}

sub MAIN("test") {
    use Test;

    for (10, 21, 25, 150, 1231, 123141, 34131) -> $n {
        is ([*] factor($n).map(-> $pair { $pair.key ** $pair.value })), $n, "$n factors correctly";
    }

    is mo(37, 1000), 100, 'mo(37,1000) == 100';
    my $b = 10**20-1;
    is mo(2, $b), 3748806900, 'mo(2,10**20-1) == 3748806900';
    is mo(17, $b), 1499522760, 'mo(17,10**20-1) == 1499522760';
    $b = 100001;
    is mo(54, $b), 9090, 'mo(54,100001) == 9090';
}
