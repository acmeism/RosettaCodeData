sub sedol( Str $s ) {
    die 'No vowels allowed' if $s  ~~ /<[AEIOU]>/;
    die 'Invalid format'    if $s !~~ /^ <[0..9B..DF..HJ..NP..TV..Z]>**6 $ /;

    my %base36 = ( 0..9, 'A'..'Z' ) Z ( ^36 );
    my @weights = 1, 3, 1, 7, 3, 9;

    my @vs = %base36{ $s.comb };
    my $checksum = [+] @vs Z* @weights;
    my $check_digit = (10 - $checksum % 10) % 10;
    return $s ~ $check_digit;
}

say sedol($_) for <
    710889
    B0YBKJ
    406566
    B0YBLH
    228276
    B0YBKL
    557910
    B0YBKR
    585284
    B0YBKT
    B00030
>;
