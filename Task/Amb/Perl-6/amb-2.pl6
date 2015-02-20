sub amb($var,*@a) {
    "[{
        @a.pick(*).map: {"||\{ $var = '$_' }"}
     }]";
}

'' ~~ m/
    :my ($a,$b,$c,$d);
    <{ amb '$a', <the that a> }>
    <{ amb '$b', <frog elephant thing> }>
    <?{ substr($a,*-1,1) eq substr($b,0,1) }>
    <{ amb '$c', <walked treaded grows> }>
    <?{ substr($b,*-1,1) eq substr($c,0,1) }>
    <{ amb '$d', <slowly quickly> }>
    <?{ substr($c,*-1,1) eq substr($d,0,1) }>
    { say "$a $b $c $d" }
    <!>
/;
