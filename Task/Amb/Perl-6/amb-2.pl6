sub amb($var,*@a) {
    "[{
        @a.pick(*).map: {"||\{ $var = '$_' }"}
     }]";
}

sub joins ($word1, $word2) {
    substr($word1,*-1,1) eq substr($word2,0,1)
}

'' ~~ m/
    :my ($a,$b,$c,$d);
    <{ amb '$a', <the that a> }>
    <{ amb '$b', <frog elephant thing> }>
    <?{ joins $a, $b }>
    <{ amb '$c', <walked treaded grows> }>
    <?{ joins $b, $c }>
    <{ amb '$d', <slowly quickly> }>
    <?{ joins $c, $d }>
    { say "$a $b $c $d" }
    <!>
/;
