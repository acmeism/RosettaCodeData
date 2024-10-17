begin % Use the Arithmetic-geometric mean to calculate Pi                    %
      %                                    - translated from the XPL0 sample %
    long real A, B, T, N, Prev_A, Pi, Prev_Pi;

    A       := 1.0;
    B       := longsqrt( 0.5 );
    T       := 0.25;
    N       := 1.0;
    Prev_Pi := 0.0;
    while begin
              Prev_A := A;
              A := ( A + B ) / 2.0;
              B := longsqrt( Prev_A * B );
              T := T - N * ( A - Prev_A ) ** 2;
              N := N + N;
              Pi := ( A + B ) ** 2 / ( 4.0 * T );
              write( r_format := "A", r_w := 20, r_d := 14, Pi );
              abs ( Prev_Pi - Pi ) >= 1'-15
          end
      do Prev_Pi := Pi;

end.
