use Prime::Factor;
use Math::Root;

sub is-square-free (Int \n) {
    constant @p = ^100 .map: { next unless .is-prime; .² };
    for @p -> \p { return False if n %% p }
    True
}

sub powerful (\n, \k = 2) {
    my @p;
    p(1, 2*k - 1);
    sub p (\m, \r) {
        @p.push(m) and return if r < k;
        for 1 .. (n / m).&root(r) -> \v {
            if r > k {
                next unless is-square-free(v);
                next unless m gcd v == 1;
            }
            p(m * v ** r, r - 1)
        }
    }
    @p
}

my $achilles = powerful(10**9).hyper(:500batch).grep( {
    my $f = .&prime-factors.Bag;
    (+$f.keys > 1) && (1 == [gcd] $f.values) && (.sqrt.Int² !== $_)
} ).classify: { .chars }

my \𝜑 = 0, |(1..*).hyper.map: -> \t { t × [×] t.&prime-factors.squish.map: { 1 - 1/$_ } }

my %as = Set.new: flat $achilles.values».list;

my $strong = lazy (flat $achilles.sort».value».list».sort).grep: { ?%as{𝜑[$_]} };

put "First 50 Achilles numbers:";
put (flat $achilles.sort».value».list».sort)[^50].batch(10)».fmt("%4d").join("\n");

put "\nFirst 30 strong Achilles numbers:";
put   $strong[^30].batch(10)».fmt("%5d").join("\n");

put "\nNumber of Achilles numbers with:";
say "$_ digits: " ~ +$achilles{$_} // 0 for 2..9;

printf "\n%.1f total elapsed seconds\n", now - INIT now;
