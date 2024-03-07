begin % Angles (geometric), normalization and conversion                      %
      %      - translation of the Algol 68 translation of the 11l sample      %

    real procedure norm ( real value x, y ) ;
    begin
        integer n;
        n := entier( abs x / abs y );
        x - ( n * y )
    end norm ;

    real procedure normd ( real value x ) ; norm( x,  360 );
    real procedure normg ( real value x ) ; norm( x,  400 );
    real procedure normm ( real value x ) ; norm( x, 6400 );
    real procedure normr ( real value x ) ; norm( x, 2 * pi );

    real procedure d2g ( real value x ) ; normd( x ) * 10 / 9;
    real procedure d2m ( real value x ) ; normd( x ) * 160 / 9;
    real procedure d2r ( real value x ) ; normd( x ) * pi / 180;

    real procedure g2d ( real value x ) ; normg( x ) * 9 / 10;
    real procedure g2m ( real value x ) ; normg( x ) * 16;
    real procedure g2r ( real value x ) ; normg( x ) * pi / 200;

    real procedure m2d ( real value x ) ; normm( x ) * 9 / 160;
    real procedure m2g ( real value x ) ; normm( x ) / 16;
    real procedure m2r ( real value x ) ; normm( x ) * pi / 3200;

    real procedure r2d ( real value x ) ; normr( x ) *  180 / pi;
    real procedure r2g ( real value x ) ; normr( x ) *  200 / pi;
    real procedure r2m ( real value x ) ; normr( x ) * 3200 / pi;

    procedure writeonF7d7 ( real value v ) ; writeon( r_format := "A", r_w := 15, r_d := 7, s_w := 0, v );

    procedure printValues ( string(82) value heading
                          ; real procedure f1, f2, f3, f4
                          ; real array values( * )
                          ; integer value numberOfValues
                          ) ;
    begin
        write( heading );
        write( "----------------------------------------------------------------------------------" );
        for i := 1 until numberOfValues do begin
            real v;
            v := values( i );
            write();
            writeonF7d7( v );
            writeon( "  " ); writeonF7d7( f1( v ) ); writeon( "  " ); writeonF7d7( f2( v ) );
            writeon( "  " ); writeonF7d7( f3( v ) ); writeon( "  " ); writeonF7d7( f4( v ) );
        end for_i ;
        write()
    end printValues ;

    real array values ( 1 :: 12 );
    values(  1 ) := -2; values( 2 ) := -1; values( 3 ) := 0; values( 4 ) := 1; values( 5 ) := 2;
    values(  6 ) := 6.2831853; values( 7 ) := 16; values( 8 ) := 57.2957795; values( 9 ) := 359;
    values( 10 ) := 399; values( 11 ) := 6399; values( 12 ) := 1000000;

    printValues( "       Degrees        Normalized         Gradians          Mils            Radians"
               , normd, d2g, d2m, d2r, values, 12
               );
    printValues( "      Gradians        Normalized         Degrees           Mils            Radians"
               , normg, g2d, g2m, g2r, values, 12
               );
    printValues( "        Mils          Normalized         Degrees         Gradians          Radians"
               , normm, m2d, m2g, m2r, values, 12
               );
    printValues( "       Radians        Normalized         Degrees         Gradians          Mils"
               , normr, r2d, r2g, r2m, values, 12
               )

end.
