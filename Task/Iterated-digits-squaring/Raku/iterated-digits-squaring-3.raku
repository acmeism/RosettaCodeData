sub endsWithOne($n --> Bool) {
    my $digit;
    my $sum = 0;
    my $nn = $n;
    loop {
        while $nn > 0 {
            $digit = $nn % 10;
            $sum += $digit²;
            $nn = $nn div 10;
        }
        return True  if $sum == 1;
        return False if $sum == 89;
        $nn = $sum;
        $sum = 0;
    }
}

my $k = 8; # 10**8
my @sums is default(0) = 1,0;
my $s;
for 1 .. $k -> $n {
    for $n*81 … 1 -> $i {
        for 1 .. 9 -> $j {
            $s = $j²;
            last if $s > $i;
            @sums[$i] += @sums[$i - $s];
        }
    }
}

my $ends-with-one = sum flat @sums[(1 .. $k*81).grep: { endsWithOne($_) }], +endsWithOne(10**$k);

say 10**$k - $ends-with-one;
