begin
    % iterative Greatest Common Divisor routine                               %
    integer procedure gcd ( integer value m, n ) ;
    begin
        integer a, b, newA;
        a := abs( m );
        b := abs( n );
        while b not = 0 do begin
            newA := b;
            b    := a rem b;
            a    := newA;
        end;
        a
    end gcd ;

    write( gcd( -21, 35 ) );
end.
