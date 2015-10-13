begin
    % algol W doesn't have standard case conversion routines, this is one way %
    % such facilities could be provided                                       %

    % converts text to upper case                                             %
    % assumes the letters are contiguous in the character set (as in ASCII)   %
    % would not work in EBCDIC (as the original algol W implementations used) %
    procedure upCase( string(256) value result text ) ;
        for i := 0 until 255 do begin
            string(1) c;
            c := text( i // 1 );
            if c >= "a" and c <= "z"
            then begin
                text( i // 1 ) := code( decode( "A" )
                                      + ( decode( c ) - decode( "a" ) )
                                      )
            end
        end upCase ;

    % converts text to lower case                                             %
    % assumes the letters are contiguous in the character set (as in ASCII)   %
    % would not work in EBCDIC (as the original algol W implementations used) %
    procedure dnCase( string(256) value result text ) ;
        for i := 0 until 255 do begin
            string(1) c;
            c := text( i // 1 );
            if c >= "A" and c <= "Z"
            then begin
                text( i // 1 ) := code( decode( "a" )
                                      + ( decode( c ) - decode( "A" ) )
                                      )
            end
        end dnCase ;

    string(256) text;
    text := "alphaBETA";
    upCase( text );
    write( text( 0 // 40 ) );
    dnCase( text );
    write( text( 0 // 40 ) );

end.
