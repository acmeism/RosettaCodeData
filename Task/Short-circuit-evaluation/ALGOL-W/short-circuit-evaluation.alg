begin

    logical procedure a( logical value v ) ; begin write( "a: ", v ); v end ;
    logical procedure b( logical value v ) ; begin write( "b: ", v ); v end ;

    write( "and: ", a( true  ) and b( true ) );
    write( "---" );
    write( "or:  ", a( true  ) or  b( true ) );
    write( "---" );
    write( "and: ", a( false ) and b( true ) );
    write( "---" );
    write( "or:  ", a( false ) or  b( true ) );
    write( "---" );

end.
