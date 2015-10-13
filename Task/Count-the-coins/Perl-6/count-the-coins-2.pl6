sub ways-to-make-change-slowly(\n, @coins) {
    my @table = [1 xx @coins], [0 xx @coins] xx n;
    for 1..n X ^@coins -> (\i, \j) {
        my \c = @coins[j];
        @table[i][j] = [+]
            @table[i - c][j    ] // 0,
            @table[i    ][j - 1] // 0;
    }
    @table[*-1][*-1];
}

say ways-to-make-change-slowly    1_00, [1,5,10,25];
say ways-to-make-change-slowly 1000_00, [1,5,10,25,50,100];
