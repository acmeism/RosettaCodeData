begin
    % show some complex arithmetic                                          %
    % returns c + d, using the builtin complex + operator                   %
    complex procedure cAdd ( complex value c, d ) ; c + d;
    % returns c * d, using the builtin complex * operator                   %
    complex procedure cMul ( complex value c, d ) ; c * d;
    % returns the negation of c, using the builtin complex unary - operator %
    complex procedure cNeg ( complex value c ) ; - c;
    % returns the inverse of c, using the builtin complex / operatror       %
    complex procedure cInv ( complex value c ) ; 1 / c;
    % returns the conjugate of c                                            %
    complex procedure cConj ( complex value c ) ; realpart( c ) - imag( imagpart( c ) );
    complex c, d;
    c := 1 + 2i;
    d := 3 + 4i;
    % set I/O format for real aand complex numbers                          %
    r_format := "A"; s_w := 0; r_w := 6; r_d := 2;
    write( "c      : ",        c      );
    write( "d      : ",           d   );
    write( "c + d  : ", cAdd(  c, d ) );
    write( "c * d  : ", cMul(  c, d ) );
    write( "-c     : ", cNeg(  c    ) );
    write( "1/c    : ", cInv(  c    ) );
    write( "conj c : ", cConj( c    ) )
end.
