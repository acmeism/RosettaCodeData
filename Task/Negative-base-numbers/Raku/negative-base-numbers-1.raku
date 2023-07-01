multi sub base ( Int $value is copy, Int $radix where -37 < * < -1) {
    my $result;
    while $value {
        my $r = $value mod $radix;
        $value div= $radix;
        if $r < 0 {
            $value++;
            $r -= $radix
        }
        $result ~= $r.base(-$radix);
    }
    flip $result || ~0;
}

multi sub base ( Real $num, Int $radix where -37 < * < -1, :$precision = -15 ) {
    return '0' unless $num;
    my $value  = $num;
    my $result = '';
    my $place  = 0;
    my $upper-bound = 1 / (-$radix + 1);
    my $lower-bound = $radix * $upper-bound;

    $value = $num / $radix ** ++$place until $lower-bound <= $value < $upper-bound;

    while ($value or $place > 0) and $place > $precision {
        my $digit = ($radix * $value - $lower-bound).Int;
        $value    =  $radix * $value - $digit;
        $result ~= '.' unless $place or $result.contains: '.';
        $result ~= $digit == -$radix ?? ($digit-1).base(-$radix)~'0' !! $digit.base(-$radix);
        $place--
    }
    $result
}

multi sub parse-base (Str $str, Int $radix where -37 < * < -1) {
    return -1 * $str.substr(1).&parse-base($radix) if $str.substr(0,1) eq '-';
    my ($whole, $frac) = $str.split: '.';
    my $fraction = 0;
    $fraction = [+] $frac.comb.kv.map: { $^v.parse-base(-$radix) * $radix ** -($^k+1) } if $frac;
    $fraction + [+] $whole.flip.comb.kv.map: { $^v.parse-base(-$radix) * $radix ** $^k }
}

# TESTING
for <4 -4 0 -7  10 -2  146 -3  15 -10  -19 -10  107 -16
    227.65625 -16  2.375 -4 -1.3e2 -8 41371457.268272761 -36> -> $v, $r {
    my $nbase = $v.&base($r, :precision(-5));
    printf "%20s.&base\(%3d\) = %-11s : %13s.&parse-base\(%3d\) = %s\n",
      $v, $r, $nbase, "'$nbase'", $r, $nbase.&parse-base($r);
}

# 'Illegal' negative-base value
say q|  '-21'.&parse-base(-10) = |, '-21'.&parse-base(-10);
