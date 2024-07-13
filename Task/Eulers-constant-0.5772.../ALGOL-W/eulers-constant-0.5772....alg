begin % calculate Euler's constant, translated from the XPL0 sample          %
      % which is translated from the C sample                                %

    long real       A, B, H, N2, R, U, V;
    long real array S ( 0 :: 1 );
    long real array B2( 0 :: 9 );
    long real       Epsilon;
    integer         K, K2, M, N;

    Epsilon := 1'-6;

    % set output format                                                      %
    i_w := 1; s_w := 0; r_w := 18; r_d := 15; r_format := "A";

    write( "From the definition, error 3e-10" );
    N := 400;  H := 1.0;
    for K1 := 2 until N do H := H + 1.0 / K1;
    comment Faster convergence: Negoi, 1997 ;
    A := Ln( N + 0.5 + 1.0/( 24.0 * N ) );
    write( "Hn    ", H );
    write( "gamma ", H - A ); write( "K = ", N ); write();

    write( "Sweeney, 1963, error 3e-10" );
    N := 21; S( 0 ) := 0;  S( 1 ) := N;
    R := N;  K:= 1;
    while begin K := K + 1;
                R := R * N / K;
                S( K rem 2 ) := S( K rem 2 ) + R / K;
                R > Epsilon
          end
    do begin end;
    write( "gamma ", S( 1 ) - S( 0 ) - ln( N ) );write( "K = ", K ); write();

    write( "Bailey, 1988" );
    N  := 5; A := 1; H := 1;
    N2 := 2 ** N;
    R := 1;  K := 1;
    while begin K := K + 1;
                R := R * N2 / K;
                H := H + 1 / K;
                B := A; A := A + R * H;
                abs( B - A ) > Epsilon
          end
    do begin end;
    A := A * N2 / Exp(N2);
    write( "gamma ", A - N * Ln( 2 ) ); write( "K = ", K ); write();

    write( "Brent-McMillan, 1980" );
    N  := 13;     A  := -Ln( N );
    B  := 1;      U  := A;  V := B;
    N2 := N * N;  K2 := 0;  K := 0;
    while begin K2 := K2 + 2 * K + 1;
                K  := K + 1;
                A  := A * N2 / K;
                B  := B * N2 / K2;
                A  := ( A + B ) / K;
                U  := U + A;
                V  := V + B;
                abs( A ) > Epsilon
          end
    do begin end;
    write( "gamma ", U / V ); write( "K = ", K ); write();

    write( "How Euler did it in 1735" );
    comment Bernoulli numbers with even indices;

    B2( 0 ) :=     1;        B2( 1 ) :=  1 /  6; B2( 2 ) :=    -1 /  30;
    B2( 3 ) :=     1 / 42;   B2( 4 ) := -1 / 30; B2( 5 ) :=     5 /  66;
    B2( 6 ) :=  -691 / 2730; B2( 7 ) :=  7 /  6; B2( 8 ) := -3617 / 510;
    B2( 9 ) := 43867 / 98;
    M := 7;  N := 10;
    comment Nth harmonic number;
    H := 1;
    for K1 := 2 until N do H := H + 1 / K1;
    write( "Hn    ", H );
    H := H - Ln( N );
    write( "  -ln ", H );
    comment Expansion C:= -digamma(1);
    A  := -1 / ( 2 * N );
    N2 := N * N;
    R  := 1;
    for K1 := 1 until M do begin
        R := R * N2;
        A := A + B2( K1 ) / (2 * K1 * R )
    end for_K1;
    write( "err   ", A ); write( "gamma ", H + A ); write( "K = ", N + M );
    write();
    write( "C  =  0.57721566490153286..." ); write()
end.
