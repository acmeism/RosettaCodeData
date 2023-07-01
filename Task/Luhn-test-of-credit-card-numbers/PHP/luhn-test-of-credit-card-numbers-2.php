function luhn_test($num) {
    $str = '';
    foreach( array_reverse( str_split( $num ) ) as $i => $c ) $str .= ($i % 2 ? $c * 2 : $c );
    return array_sum( str_split($str) ) % 10 == 0;
}

foreach (array('49927398716','49927398717','1234567812345678','1234567812345670') as $n)
    echo "$n is ", luhn_test($n) ? 'valid' : 'not valid', "</br>\n";
