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

multi sub base (Numeric $num, Complex $radix where *.re == 0, :$precision = -8 ) {
    die "Base $radix out of range" unless -6 <= $radix.im <= -2 or 2 <= $radix.im <= 6;
    my ($re, $im) = $num.Complex.reals;
    my ($re-wh, $re-fr) =             $re.&base( -$radix.im².Int, :precision($precision) ).split: '.';
    my ($im-wh, $im-fr) = ($im/$radix.im).&base( -$radix.im².Int, :precision($precision) ).split: '.';
    $_ //= '' for $re-fr, $im-fr;

    sub zip (Str $a, Str $b) {
        my $l = '0' x ($a.chars - $b.chars).abs;
        ([~] flat ($a~$l).comb Z flat ($b~$l).comb).subst(/ '0'+ $ /, '') || '0'
    }

    my $whole = flip zip $re-wh.flip, $im-wh.flip;
    my $fraction = zip $im-fr, $re-fr;
    $fraction eq 0 ?? "$whole" !! "$whole.$fraction"
}

multi sub parse-base (Str $str, Complex $radix where *.re == 0) {
    return -1 * $str.substr(1).&parse-base($radix) if $str.substr(0,1) eq '-';
    my ($whole, $frac) = $str.split: '.';
    my $fraction = 0;
    $fraction = [+] $frac.comb.kv.map: { $^v.parse-base($radix.im².Int) * $radix ** -($^k+1) } if $frac;
    $fraction + [+] $whole.flip.comb.kv.map: { $^v.parse-base($radix.im².Int) * $radix ** $^k }
}

# TESTING
for 0, 2i, 1, 2i, 5, 2i, -13, 2i, 9i, 2i, -3i, 2i, 7.75-7.5i, 2i, .25, 2i, # base 2i tests
    5+5i,  2i, 5+5i,  3i, 5+5i,  4i, 5+5i,  5i, 5+5i,  6i, # same value, positive imaginary bases
    5+5i, -2i, 5+5i, -3i, 5+5i, -4i, 5+5i, -5i, 5+5i, -6i, # same value, negative imaginary bases
    227.65625+10.859375i, 4i, # larger test value
    31433.3487654321-2902.4480452675i, 6i # heh
  -> $v, $r {
my $ibase = $v.&base($r, :precision(-6));
printf "%33s.&base\(%2si\) = %-11s : %13s.&parse-base\(%2si\) = %s\n",
  $v, $r.im, $ibase, "'$ibase'", $r.im, $ibase.&parse-base($r).round(1e-10).narrow;
}
