sub Ed-Pegg-jr (\n) {
    return 1 if n == 1;
    my ($count, $power-mod-n) = 0, 1;
    my @oom-mod-n = 0; # orders of magnitude of 10 mod n
    my @dig-mod = 0;   # 1 to n + oom mod n
    for 1..n -> \i {
        @oom-mod-n[i] = $power-mod-n;
        for 1..n -> \j {
            my \k = (j + $power-mod-n - 1) % n + 1;
            @dig-mod[k] = i if @dig-mod[j] and @dig-mod[j] != i and !@dig-mod[k];
        }
        @dig-mod[$power-mod-n + 1] ||= i;
        ($power-mod-n *= 10) %= n;
        last if @dig-mod[1];
    }
    my ($b10, $remainder) = '', n;
    while $remainder {
        my $place = @dig-mod[$remainder % n + 1];
        $b10 ~= '0' x ($count - $place) if $count > $place;
        $count = $place - 1;
        $b10 ~= '1';
        $remainder = (n + $remainder - @oom-mod-n[$place]) % n;
    }
    $b10 ~ '0' x $count
}

printf "%5s: %28s  %s\n", 'Number', 'B10', 'Multiplier';

for flat 1..10, 95..105, 297, 576, 594, 891, 909, 999, 1998, 2079, 2251, 2277, 2439, 2997, 4878 {
    printf "%6d: %28s  %s\n", $_, my $a = Ed-Pegg-jr($_), $a / $_;
}
