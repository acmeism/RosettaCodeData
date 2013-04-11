multi div($a, $b){ return $a / $b }
multi div($a, $b where { $b == 0 }){
    say 'lolicheatsyou';
    return 1;
}

say div(1, sin(0)); # prints "lolicheatsyou" newline "1"
