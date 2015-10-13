begin
    % iterative Greatest Common Divisor routine                               %
    integer procedure gcd ( integer value m, n ) ;
    begin
        integer a, b, newA;
        a := abs( m );
        b := abs( n );
        if a = 0 then begin
            b
            end
        else begin
            while b not = 0 do begin
                newA := b;
                b    := a rem b;
                a    := newA;
            end;
            a
        end
    end gcd ;

    write( gcd( -21, 35 ) );
end.
