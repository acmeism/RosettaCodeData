unit sub MAIN ( :$for, :$at = 0 );

put slurp.split( /\n\n+/ ).grep( { .contains: $for } )
         .map( { .substr: .index: $at } )
         .join: "\n----------------\n"
