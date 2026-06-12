BEGIN # Welch's t-test - translation of the Go and Kotlin samples             #

    PROC gammak = ( REAL d )REAL:        # ALGOL 68 Genie has a builtin gamma #
         IF   d < 0.5      # remove this PROC if you are using ALGOL 68 Genie #
         THEN pi / (sin(pi * d) * gammak(1.0 - d))
         ELSE []REAL p   = []REAL(     0.99999999999980993
                                 ,   676.5203681218851
                                 , -1259.1392167224028
                                 ,   771.32342877765313
                                 ,  -176.61502916214059
                                 ,    12.507343278686905
                                 ,    -0.13857109526572012
                                 ,     9.9843695780195716e-6
                                 ,     1.5056327351493116e-7
                                 )[ AT 0 ];
              INT  g   = UPB p - 1;
              REAL dd  = d - 1;
              REAL a  := p[0];
              REAL t   = dd + g + 0.5;
              FOR i FROM 1 TO len(p) - 1 DO a +:= p[i] / (dd + i) OD;
              sqrt(2 * pi) * pow(t, dd + 0.5) * exp(-t) * a
         FI # gammak # ;

    PROC pow = ( REAL v, p )REAL: IF p = 0 THEN 1 ELIF v = 0 THEN 0 ELSE v ^ p FI;
    PROC square = ( REAL v )REAL: v * v;

    PROC lgamma = ( REAL d )REAL: ln( gammak( d ) );    # replace gammak with #
                                      # gamma if you are using ALGOL 60 Genie #

    PROC len = ( []REAL v )INT: ( UPB v - LWB v ) + 1;

    PROC mean = ( []REAL a )REAL:
         BEGIN
            REAL sum := 0;
            FOR x FROM LWB a TO UPB a DO
                sum +:= a[ x ]
            OD;
            sum / len(a)
         END # mean # ;

    PROC sv = ( []REAL a )REAL:
         BEGIN
            REAL m    = mean(a);
            REAL sum := 0;
            FOR x FROM LWB a TO UPB a DO
                REAL d = a[ x ] - m;
                sum  +:= d * d
            OD;
            sum / (len(a)-1)
         END # sv # ;

    PROC welch = ( []REAL a, b )REAL:
         (mean(a) - mean(b)) / sqrt(sv(a)/(len(a))+sv(b)/(len(b)));

    PROC dof = ( []REAL da1, da2 )REAL:
         BEGIN
             REAL s1    = sv(da1);
             REAL s2    = sv(da2);
             INT  n1    = len(da1);
             INT  n2    = len(da2);
             REAL temp1 = square(s1 / n1 + s2 / n2);
             REAL temp2 = square(s1) / (n1 * n1 * (n1 - 1)) + square(s2) / (n2 * n2 * (n2 - 1));
             temp1 / temp2
         END # dof # ;

    PROC simpson = ( REAL a, b, INT n, PROC(REAL)REAL f )REAL:
         BEGIN
             REAL h    = (b - a) / n;
             REAL sum := 0.0;
             FOR i FROM 0 TO n - 1 DO
                REAL x = a + i * h;
                sum +:= (f(x) + 4.0 * f(x + h / 2.0) + f(x + h)) / 6.0
             OD;
             sum * h
         END # simpson # ;

    PROC p value = ( []REAL da1, da2 )REAL:
         BEGIN
             REAL nu = dof(da1, da2)
                , t  = welch(da1, da2)
                , g  = exp( lgamma(nu / 2.0) + lgamma(0.5) - lgamma(nu / 2.0 + 0.5))
                , b  = nu / (t * t + nu)
                ;
             PROC f = ( REAL r )REAL: pow(r, nu / 2.0 - 1.0) / sqrt(1.0 - r);
             simpson(0.0, b, 10000, f) / g
         END # p value # ;

    BEGIN                                                        # test cases #
        []REAL d1 = ( 27.5, 21.0, 19.0, 23.6, 17.0, 17.9, 16.9, 20.1, 21.9, 22.6
                    , 23.1, 19.6, 19.0, 21.7, 21.4 )
             , d2 = ( 27.1, 22.0, 20.8, 23.4, 23.4, 23.5, 25.8, 22.0, 24.8, 20.2
                    , 21.9, 22.1, 22.9, 20.5, 24.4 )
             , d3 = ( 17.2, 20.9, 22.6, 18.1, 21.7, 21.4, 23.5, 24.2, 14.7, 21.8 )
             , d4 = ( 21.5, 22.8, 21.0, 23.0, 21.6, 23.6, 22.5, 20.7, 23.4, 21.8
                    , 20.7, 21.7, 21.5, 22.5, 23.6, 21.5, 22.5, 23.5, 21.5, 21.8 )
             , d5 = ( 19.8, 20.4, 19.6, 17.8, 18.5, 18.9, 18.3, 18.9, 19.5, 22.0 )
             , d6 = ( 28.2, 26.6, 20.1, 23.3, 25.2, 22.1, 17.7, 27.6, 20.6, 13.7
                    , 23.2, 17.5, 20.6, 18.0, 23.9, 21.6, 24.3, 20.4, 24.0, 13.2 )
             , d7 = ( 30.02, 29.99, 30.11, 29.97, 30.01, 29.99 )
             , d8 = ( 29.89, 29.93, 29.72, 29.98, 30.02, 29.98 )
             , x  = ( 3.0, 4.0, 1.0, 2.1 )
             , y  = ( 490.2, 340.0, 433.9 )
             ;

        print( ( fixed( p value( d1, d2 ), -10, 6 ), newline ) );
        print( ( fixed( p value( d3, d4 ), -10, 6 ), newline ) );
        print( ( fixed( p value( d5, d6 ), -10, 6 ), newline ) );
        print( ( fixed( p value( d7, d8 ), -10, 6 ), newline ) );
        print( ( fixed( p value( x,  y  ), -10, 6 ), newline ) )
    END
END
