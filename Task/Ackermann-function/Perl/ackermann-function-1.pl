{
    my @memo;
    sub A {
        my( $m, $n ) = @_;
        $memo[ $m ][ $n ] and return $memo[ $m ][ $n ];
        $m or return $n + 1;
        return $memo[ $m ][ $n ] = (
            $n
               ? A( $m - 1, A( $m, $n - 1 ) )
               : A( $m - 1, 1 )
        );
    }
}
