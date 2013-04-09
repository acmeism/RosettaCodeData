function binary_search( $array, $secret, $start, $end )
{
        do
        {
                $guess = (int)($start + ( ( $end - $start ) / 2 ));

                if ( $array[$guess] > $secret )
                        $end = $guess;

                if ( $array[$guess] < $secret )
                        $start = $guess;

                if ( $end < $start)
                        return -1;

        } while ( $array[$guess] != $secret );

        return $guess;
}
