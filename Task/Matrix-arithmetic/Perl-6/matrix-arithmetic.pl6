sub insert( $x, @xs) { [@xs[0..$_-1], $x, @xs[$_..*]] for 0..@xs }
sub order ($sg, @xs) { $sg > 0 ?? @xs !! @xs.reverse }

multi σ_permutations ([]) { [] => 1 }

multi σ_permutations ([$x, *@xs]) {
    σ_permutations(@xs).map({ order($_.value, insert($x, $_.key)) }) Z=> (1,-1) xx *
}

sub m_arith ( @a, $op ) {
    note "Not a square matrix" and return
      if [||] map { @a.elems cmp @a[$_].elems }, ^@a;
    [+] map {
        my $permutation = .key;
        my $term = $op eq 'perm' ?? 1 !! .value;
        for $permutation.kv -> $i, $j { $term *= @a[$i][$j] };
        $term
    }, σ_permutations [^@a];
}

########### Testing ###########

my @tests = (
    [
        [ 1, 2 ],
        [ 3, 4 ]
    ],
    [
        [  1,  2,  3,  4 ],
        [  4,  5,  6,  7 ],
        [  7,  8,  9, 10 ],
        [ 10, 11, 12, 13 ]
    ],
    [
        [  0,  1,  2,  3,  4 ],
        [  5,  6,  7,  8,  9 ],
        [ 10, 11, 12, 13, 14 ],
        [ 15, 16, 17, 18, 19 ],
        [ 20, 21, 22, 23, 24 ]
    ]
);

sub dump (@matrix) {
    say $_».fmt: "%3s" for @matrix, '';
}

for @tests -> @matrix {
    say 'Matrix:';
    @matrix.&dump;
    say "Determinant:\t", @matrix.&m_arith: <det>;
    say "Permanent:  \t", @matrix.&m_arith: <perm>;
    say '-' x 25;
}
