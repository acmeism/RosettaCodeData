USING: formatting io kernel math math.matrices sequences vectors ;

: next-row ( prev -- next )
    [ 1 1vector ]
    [ dup last [ + ] accumulate swap suffix! ] if-empty ;

: aitken ( n -- seq )
    V{ } clone swap [ next-row dup ] replicate nip ;

0 50 aitken col [ 15 head ] [ last ] bi
"First 15 Bell numbers:\n%[%d, %]\n\n50th: %d\n\n" printf
"First 10 rows of the Bell triangle:" print
10 aitken [ "%[%d, %]\n" printf ] each
