sub super (\x) { x.trans([<0123456789>.comb] => [<⁰¹²³⁴⁵⁶⁷⁸⁹>.comb]) }

sub is-square-free (Int \n) {
    constant @p = ^100 .map: { next unless .is-prime; .² };
    for @p -> \p { return False if n %% p }
    True
}

sub powerfuls (\n, \k, \enumerate = False) {
    my @powerful;
    p(1, 2*k - 1);
    sub p (\m, \r) {
        if r < k {
            enumerate ?? @powerful.push(m) !! ++@powerful[m - 1  ?? (m - 1).chars !! 0];
            return
        }
        for 1 .. ((n / m) ** (1/r) + .0001).Int -> \v {
            if r > k {
                next unless is-square-free(v);
                next unless m gcd v == 1;
            }
            p(m * v ** r, r - 1)
        }
    }
    @powerful;
}

put "Count and first and last five enumerated n-powerful numbers in 10ⁿ:";
for 2..10 -> \k {
    my @powerful = sort powerfuls(10**k, k, True);
    printf "%2d %2s-powerful numbers <= 10%-2s: %s ... %s\n", +@powerful, k, super(k),
           @powerful.head(5).join(", "), @powerful.tail(5).join(", ");
}

put "\nCounts in each order of magnitude:";
my $top = 9;
for 2..10 -> \k {
    printf "%2s-powerful numbers <= 10ⁿ (where 0 <= n <= %d): ", k, $top+k;
    quietly say join ', ', [\+] powerfuls(10**($top + k), k);
}
