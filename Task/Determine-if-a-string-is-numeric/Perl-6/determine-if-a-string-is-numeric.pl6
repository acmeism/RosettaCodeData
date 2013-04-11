sub is-number( $term --> Bool ) {
   $term ~~ /\d/ and +$term ~~ Numeric;
}
say "true" if is-number( 10111 );
