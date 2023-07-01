sub strip_chars ( $s, $chars ) {
    return $s.trans( $chars.comb X=> '' );
}

say strip_chars( 'She was a soul stripper. She took my heart!', 'aei' );
