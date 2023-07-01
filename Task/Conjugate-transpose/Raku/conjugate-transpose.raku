for [ # Test Matrices
       [   1, 1+i, 2i],
       [ 1-i,   5, -3],
       [0-2i,  -3,  0]
    ],
    [
       [1, 1, 0],
       [0, 1, 1],
       [1, 0, 1]
    ],
    [
       [0.707 ,    0.707,  0],
       [0.707i, 0-0.707i,  0],
       [0     ,        0,  i]
    ]
    -> @m {
        say "\nMatrix:";
        @m.&say-it;
        my @t = @m».conj.&mat-trans;
        say "\nTranspose:";
        @t.&say-it;
        say "Is Hermitian?\t{is-Hermitian(@m, @t)}";
        say "Is Normal?\t{is-Normal(@m, @t)}";
        say "Is Unitary?\t{is-Unitary(@m, @t)}";
    }

sub is-Hermitian (@m, @t, --> Bool) {
    so @m».Complex eqv @t».Complex
 }

sub is-Normal (@m, @t, --> Bool) {
    so mat-mult(@m, @t)».Complex eqv mat-mult(@t, @m)».Complex
}

sub is-Unitary (@m, @t, --> Bool) {
    so mat-mult(@m, @t, 1e-3)».Complex eqv mat-ident(+@m)».Complex;
}

sub mat-trans (@m) { map { [ @m[*;$_] ] }, ^@m[0] }

sub mat-ident ($n) { [ map { [ flat 0 xx $_, 1, 0 xx $n - 1 - $_ ] }, ^$n ] }

sub mat-mult (@a, @b, \ε = 1e-15) {
    my @p;
    for ^@a X ^@b[0] -> ($r, $c) {
        @p[$r][$c] += @a[$r][$_] * @b[$_][$c] for ^@b;
        @p[$r][$c].=round(ε); # avoid floating point math errors
    }
    @p
}

sub say-it (@array) { $_».fmt("%9s").say for @array }
