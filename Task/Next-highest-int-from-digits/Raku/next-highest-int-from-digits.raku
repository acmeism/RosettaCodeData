use Lingua::EN::Numbers;

sub next-greatest-index ($str, &op = &infix:«<» ) {
    my @i = $str.comb;
    (1..^@i).first: { &op(@i[$_ - 1], @i[$_]) }, :end, :k;
}

multi next-greatest-integer (Int $num where * >= 0) {
    return 0 if $num.chars < 2;
    return $num.flip > $num ?? $num.flip !! 0 if $num.chars == 2;
    return 0 unless my $i = next-greatest-index( $num ) // 0;
    my $digit = $num.substr($i, 1);
    my @rest  = (flat $num.substr($i).comb).sort(+*);
    my $next  = @rest.first: * > $digit, :k;
    $digit    = @rest.splice($next,1);
    join '', flat $num.substr(0,$i), $digit, @rest;
}

multi next-greatest-integer (Int $num where * < 0) {
    return 0 if $num.chars < 3;
    return $num.abs.flip < -$num ?? -$num.abs.flip !! 0 if $num.chars == 3;
    return 0 unless my $i = next-greatest-index( $num, &CORE::infix:«>» ) // 0;
    my $digit = $num.substr($i, 1);
    my @rest  = (flat $num.substr($i).comb).sort(-*);
    my $next  = @rest.first: * < $digit, :k;
    $digit    = @rest.splice($next,1);
    join '', flat $num.substr(0,$i), $digit, @rest;
}

say "Next largest integer able to be made from these digits, or zero if no larger exists:";
printf "%30s  -> %s%s\n", .&comma, .&next-greatest-integer < 0 ?? '' !! ' ', .&next-greatest-integer.&comma for
    flat 0, (9, 12, 21, 12453, 738440, 45072010, 95322020, 9589776899767587796600, 3345333,
    95897768997675877966000000000000000000000000000000000000000000000000000000000000000000).map: { $_, -$_ };
