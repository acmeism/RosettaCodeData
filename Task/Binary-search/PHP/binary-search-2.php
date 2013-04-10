function binary_search( $array, $secret, $start, $end )
{
        $guess = (int)($start + ( ( $end - $start ) / 2 ));

        if ( $end < $start)
                return -1;

        if ( $array[$guess] > $secret )
                return (binary_search( $array, $secret, $start, $guess ));

        if ( $array[$guess] < $secret )
                return (binary_search( $array, $secret, $guess, $end ) );

        return $guess;
}
