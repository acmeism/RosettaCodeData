# Recursive (cached)
sub change-r($amount, @coins) {
    my @cache = [1 xx @coins], |([] xx $amount);

    multi ways($n where $n >= 0, @now [$coin,*@later]) {
        @cache[$n;+@later] //= ways($n - $coin, @now) + ways($n, @later);
    }
    multi ways($,@) { 0 }

    # more efficient to start with coins sorted in descending order
    ways($amount, @coins.sort(-*).list);
}

# Iterative
sub change-i(\n, @coins) {
    my @table = [1 xx @coins], [0 xx @coins] xx n;
    (1..n).map: -> \i {
        for ^@coins -> \j {
        my \c = @coins[j];
        @table[i;j] = [+]
            @table[i - c;j] // 0,
            @table[i;j - 1] // 0;
        }
    }
    @table[*-1][*-1];
}

say "Iterative:";
say change-i    1_00, [1,5,10,25];
say change-i 1000_00, [1,5,10,25,50,100];

say "\nRecursive:";
say change-r    1_00, [1,5,10,25];
say change-r 1000_00, [1,5,10,25,50,100];
