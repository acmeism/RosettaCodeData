put join ', ', sort +*, unique flat
   < 2 2 2 2 2 3 3 3 5 5 7 >.combinations
   .grep( *.sum == 13 )
   .map( { .join => $_ } )
   .map: { .value.permutations».join }
