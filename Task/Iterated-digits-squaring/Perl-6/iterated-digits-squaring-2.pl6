my @cache;
@cache[1] = 1;
@cache[89] = 89;

sub Euler92(int $n) {
    $n < 649  # 99,999,999 sums to 648, so no point remembering more
        ?? (@cache.AT-POS($n) //= ids($n))
        !! ids($n)
}

sub ids(int $num --> int) {
    my int $n = $num;
    my int $ten = 10;
    my int $sum = 0;
    my int $t;
    my int $c;
    repeat until $n == 89 or $n == 1 {
        $sum = 0;
        repeat {
            $t = $n div $ten;
            $c = $n - $t * $ten;
            $sum = $sum + $c * $c;
        } while $n = $t;
        $n = @cache.AT-POS($sum) // $sum;
    }
    $n;
}

my int $cnt = 0;
for 1 .. 100_000_000 -> int $n {
   $cnt = $cnt + 1 if Euler92($n) == 89;
}
say $cnt;
