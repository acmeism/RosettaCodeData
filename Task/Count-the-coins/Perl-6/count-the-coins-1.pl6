sub ways-to-make-change($amount, @coins) {
    my @cache = $[1 xx @coins];

    multi ways($n where $n >= 0, @now [$coin,*@later]) {
        @cache[$n][+@later] //= ways($n - $coin, @now) + ways($n, @later);
    }
    multi ways($,@) { 0 }

    ways($amount, @coins.sort(-*).list);  # sort descending
}

say ways-to-make-change    1_00, [1,5,10,25];
say ways-to-make-change 1000_00, [1,5,10,25,50,100];
