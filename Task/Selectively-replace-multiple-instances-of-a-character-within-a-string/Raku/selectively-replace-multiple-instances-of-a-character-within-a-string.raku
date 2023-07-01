sub mangle ($str is copy) {
    $str.match(:ex, 'a')».from.map: { $str.substr-rw($_, 1) = 'ABaCD'.comb[$++] };
    $str.=subst('b', 'E');
    $str.substr-rw($_, 1) = 'F' given $str.match(:ex, 'r')».from[1];
    $str
}

say $_, ' -> ', .&mangle given 'abracadabra';

say $_, ' -> ', .&mangle given 'abracadabra'.comb.pick(*).join;
