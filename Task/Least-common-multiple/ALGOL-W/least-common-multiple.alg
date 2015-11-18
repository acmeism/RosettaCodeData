begin
    integer procedure gcd ( integer value a, b ) ;
        if b = 0 then a else gcd( b, a rem abs(b) );

    integer procedure lcm( integer value a, b ) ;
        abs( a * b ) div gcd( a, b );

    write( lcm( 15, 20  ) );
end.
